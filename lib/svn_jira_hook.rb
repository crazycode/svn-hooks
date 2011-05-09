# encoding: utf-8
require "jira4r/jira_tool"
require "yaml"

class JiraHook

  def initialize(base_url = nil)
    @jira = ::Jira4R::JiraTool.new(2, base_url) unless base_url.nil?
  end

  def login(user, pass)
    @jira.login(user, pass)
  end


  def self.check(argv, keyprefix, config = nil)
    repo_path = argv[0]
    transaction = argv[1]
    svnlook = 'svnlook'


    #commit_dirs_changed = `#{svnlook} dirs-changed #{repo_path} -t #{transaction}`
    #commit_changed = `#{svnlook} changed #{repo_path} -t #{transaction}`
    commit_author = `#{svnlook} author #{repo_path} -t #{transaction}`.chop
    commit_log = `#{svnlook} log #{repo_path} -t #{transaction}`
    #commit_diff = `#{svnlook} diff #{repo_path} -t #{transaction}`
    #commit_date = `#{svnlook} date #{repo_path} -t #{transaction}`

    if commit_log.nil? || commit_log.empty?
      STDERR.puts("'#{commit_log}' doesn't exist as a issue on Jira")
      exit(1)
    end

    check(commit_author, commit_log, keyprefix, config)
  end

  def self.check(commit_author, commit_log, keyprefix, config = nil)
    if config
      jira_configuration = config
    else
      # TODO die if configuration file is missing
      jira_configuration = configuration()
    end

    jira = JiraHook.new(jira_configuration['jira_url'])
    jira.login(jira_configuration['jira_username'], jira_configuration['jira_password'])

    unless jira.check_right(commit_author, keyprefix, commit_log)
      STDERR.puts("Doesn't exist as a issue on Jira!\n： #{keyprefix}-10: 修改说明")
      exit(1)
    end

  end

  # check the message is match the issue_key_regex
  # and assign to the user
  def check_right(username, issue_key_regex, message)
    if message.nil? || message.empty?
      return false
    end
    issue_id = get_issue_number(message, issue_key_regex)
    if issue_id.nil?
      return false
    end
    has_right(username, issue_id)
  end

  def has_right(username, issue_id)
    begin
      issue = @jira.getIssue(issue_id)
      if issue.assignee == username && issue.status == '3'
        return true
      else
        return false
      end
    rescue SOAP::FaultError
      return false
    end
  end

  def get_issue_number(message, keyprefix)
    # key="ab" => key=[Aa][Bb]
    keyreg = []
    keyprefix.each_char do |c|
      keyreg << "[#{c.upcase}#{c.downcase}]"
    end

    re = Regexp.new("#{keyreg.join("")}-[0-9]+")
    if message =~ re
      "#{$&}".upcase
    end
  end

  def self.configuration
    if defined?(SVN_HOOKS_CONFIG_PATH)
      config_file = SVN_HOOKS_CONFIG_PATH
    else
      config_file = '/etc/svn_hooks.yml'
    end

    YAML::load(IO.read(config_file))
  end

end


