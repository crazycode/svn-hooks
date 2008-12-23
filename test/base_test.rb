require File.dirname(__FILE__) + '/test_helper'

class BaseTest < Test::Unit::TestCase
  def test_simple
    assert_equal 1, 1
  end

  def test_get_issue_number
    assert_nil getIssueNumber("helo,ixist", "SB")
    isn = getIssueNumber("SB-1: Test", "SB")
    assert_not_nil isn
    assert_equal "SB-1", isn
  end

  private 
  def getIssueNumber(message, key)
    re = Regexp.new("#{key}-[0-9]+")
    if message =~ re
      "#{$&}"
    end
  end
end

