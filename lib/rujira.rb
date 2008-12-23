require "jira4r/jira_tool"

class RuJira

  def initialize(base_url)
    @jira = ::Jira4R::JiraTool.new(2, base_url)
  end
  
  def login(user, pass)
    @jira.login(user, pass)
  end

  # check the message is match the issue_key
  # and assign to the user
  def check_right(username, issue_key, message)
    if message.nil? || message.empty?
      return false
    end
    issue_id = getIssueNumber(message, issue_key)
    has_right(username, issue_id)
  end

  def has_right(username, issue_id)
    begin
      issue = @jira.getIssue(issue_id)
      if issue.assignee == username
        return true
      else
        return false
      end
    rescue SOAP::FaultError 
      return false
    end
  end

  def getIssueNumber(message, key)
    re = Regexp.new("#{key}-[0-9]+")
    if message =~ re
      "#{$&}"
    end
  end

end


