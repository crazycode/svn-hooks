require "jira4r/jira_tool"

class RuJira

  def initialize(base_url)
    @jira = ::Jira4R::JiraTool.new(2, base_url)
  end
  
  def login(user, pass)
    @jira.login(user, pass)
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


