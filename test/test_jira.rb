require 'test_helper'

SVN_HOOKS_CONFIG_PATH = File.dirname(__FILE__) + '/config/svn_hooks.yml'

class TestJira < Test::Unit::TestCase
  def test_simple
    assert_equal 1, 1
  end

  def test_get_issue_number
    jira = JiraHook.new
    assert_nil jira.get_issue_number("helo,ixist", "SB")
    assert_nil jira.get_issue_number("SB:helo,ixist", "SB")
    assert_nil jira.get_issue_number("SB-: helo,ixist", "SB")
    assert_nil jira.get_issue_number("helo,ixSBist", "SB")
    assert_nil jira.get_issue_number("helo,iSB-xist", "SB")
    isn = jira.get_issue_number("SB-1: Test", "SB")
    assert_not_nil isn
    assert_equal "SB-1", isn
    assert_equal "SB-34234", jira.get_issue_number("hello SB-34234", "SB")
    assert_equal "SB-34234", jira.get_issue_number("hello SB-34234abcd", "SB")
    assert_equal "SB-34234", jira.get_issue_number("hello SB-34234", "sb")
    assert_equal "SB-34234", jira.get_issue_number("hello sB-34234abcd", "sb")
    assert_equal "SB-34234", jira.get_issue_number("hello Sb-34234", "SB")
    assert_equal "SB-34234", jira.get_issue_number("hello sB-34234abcd", "Sb")
    assert_equal "SB-34234", jira.get_issue_number("hello Sb-34234", "sb")
    assert_equal "SB-34234", jira.get_issue_number("hello sb-34234abcd", "sB")
  end


  def test_check_jira
    # JiraHook.check("tangliqun", "Message-99:hello", 'Message')
  end

end

