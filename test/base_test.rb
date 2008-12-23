require File.dirname(__FILE__) + '/test_helper'

class BaseTest < Test::Unit::TestCase
  def test_simple
    assert_equal 1, 1
  end

  def test_get_issue_number
    assert_nil getIssueNumber("helo,ixist", "SB")
    assert_nil getIssueNumber("SB:helo,ixist", "SB")
    assert_nil getIssueNumber("SB-: helo,ixist", "SB")
    assert_nil getIssueNumber("helo,ixSBist", "SB")
    assert_nil getIssueNumber("helo,iSB-xist", "SB")
    isn = getIssueNumber("SB-1: Test", "SB")
    assert_not_nil isn
    assert_equal "SB-1", isn
    assert_equal "SB-34234", getIssueNumber("hello SB-34234", "SB")
    assert_equal "SB-34234", getIssueNumber("hello SB-34234abcd", "SB")
    assert_equal "SB-34234", getIssueNumber("hello SB-34234", "[Ss][Bb]")
    assert_equal "SB-34234", getIssueNumber("hello sB-34234abcd", "[Ss][Bb]")
    assert_equal "SB-34234", getIssueNumber("hello Sb-34234", "[Ss][Bb]")
    assert_equal "SB-34234", getIssueNumber("hello sB-34234abcd", "[Ss][Bb]")
    assert_equal "SB-34234", getIssueNumber("hello Sb-34234", "[Ss][Bb]")
    assert_equal "SB-34234", getIssueNumber("hello sb-34234abcd", "[Ss][Bb]")
  end

  private 
  def getIssueNumber(message, keyreg)
    re = Regexp.new("#{keyreg}-[0-9]+")
    if message =~ re
      "#{$&}".upcase
    end
  end
end

