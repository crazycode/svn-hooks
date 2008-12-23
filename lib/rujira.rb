require "jira4r/jira_tool"

  class RuJira

    def initialize(base_url)
      @jira = ::Jira4R::JiraTool.new(2, base_url)
    end
    
    def login(user, pass)
      @jira.login(user, pass)
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
  end


