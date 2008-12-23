require 'rubygems'

spec = Gem::Specification.new do |s|

  s.name = 'rujira'
  s.version = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.summary = "rujira is a pure-Ruby JIRA client library to check user's issue right."
  s.files = Dir.glob("lib/**/*").delete_if { |item| item.include?(".git") }
  s.require_path = 'lib'
  
  s.has_rdoc=false

  s.author = "Tang Liqun"
  s.email = "crazycode@gmail.com"
  s.homepage = "http://github.com/crazycode/rujira"

end

if $0==__FILE__
  Gem::manage_gems
  Gem::Builder.new(spec).build
end
