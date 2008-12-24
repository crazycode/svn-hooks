#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'rujira'

repo_path = ARGV[0]
transaction = ARGV[1]
svnlook = '/usr/bin/svnlook'

commit_dirs_changed = `#{svnlook} dirs-changed #{repo_path} -t #{transaction}`
commit_changed = `#{svnlook} changed #{repo_path} -t #{transaction}`
commit_author = `#{svnlook} author #{repo_path} -t #{transaction}`.chop
commit_log = `#{svnlook} log #{repo_path} -t #{transaction}`
#commit_diff = `#{svnlook} diff #{repo_path} -t #{transaction}`
#commit_date = `#{svnlook} date #{repo_path} -t #{transaction}`

if commit_log.nil? || commit_log.empty?
  STDERR.puts("提交注释必须填写，而且需要包括分配给你的bug号!")
  exit(1)
end

jira = RuJira.new('http://192.168.0.3/jira')
jira.login('username', 'password')

unless jira.check_right(commit_author, '[Ss][Bb]', commit_log)
  STDERR.puts("提交注释中必须包括分配给你的bug号!\n例如： SB-10: 修改说明")
  exit(1)
end
