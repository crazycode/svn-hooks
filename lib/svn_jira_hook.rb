# encoding: utf-8
require "jira4r/jira_tool"


class JiraHook

  def initialize(base_url)
    @jira = ::Jira4R::JiraTool.new(2, base_url)
  end

  def login(user, pass)
    @jira.login(user, pass)
  end

  def self.check(argv)
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
      STDERR.puts("提交注释必须填写，而且需要包括分配给你的bug号!")
      exit(1)
    end

    jira = JiraHook.new('http://192.168.0.3/jira')
    jira.login('username', 'password')

    unless jira.check_right(commit_author, '[Ss][Bb]', commit_log)
      STDERR.puts("提交注释中必须包括分配给你的bug号!\n例如： SB-10: 修改说明")
      exit(1)
    end

  end

  # check the message is match the issue_key_regex
  # and assign to the user
  def check_right(username, issue_key_regex, message)
    if message.nil? || message.empty?
      return false
    end
    issue_id = getIssueNumber(message, issue_key_regex)
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

  def getIssueNumber(message, keyreg)
    re = Regexp.new("#{keyreg}-[0-9]+")
    if message =~ re
      "#{$&}".upcase
    end
  end

end


