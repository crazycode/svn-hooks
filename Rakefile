require 'fileutils'
require 'rake/clean'
require 'logger'

begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
  nil
end

logger = Logger.new(STDERR)
logger.level = Logger::INFO


desc "build gem"
task :default => [:build_gem]

task :build_gem do
  system("gem build rujira.gemspec")
end

task :install_gem do
  system("gem install *.gem")
end  
