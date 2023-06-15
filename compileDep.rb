#!/usr/bin/env ruby
require 'optparse'
require 'open3'
require_relative 'utils/logger.rb'
require 'fileutils'
status = []
result = ''
ARGF.each_with_index do |line, idx|
  STDERR.print idx, ":", line
  STDERR.puts 
  dep, old_ver, new_ver = line.scan(/^(.*)="([^"]+)" "([^"]+)"$/).last
    
    
  stdin, stdout, stderr, wait_thr = Open3.popen3("git checkout ext.gradle && sed -i '' -e 's/^ *#{dep} = \"#{old_ver}.*$/#{dep}=\"#{new_ver}\"/' ext.gradle && git diff ext.gradle" )
  exit_code =  wait_thr.value
  out = stdout.gets(nil)
  stdout.close
  STDERR.puts out
  err = stderr.gets(nil)
  stderr.close
  STDERR.puts err
    
  stdin, stdout, stderr, wait_thr = Open3.popen3("./gradlew clean assembleDebug" )
#  result = stdout.gets(nil)
  stdout.close
  err = stderr.gets(nil)
  stderr.close

  STDERR.puts err
  exit_code =  wait_thr.value
  
    if exit_code.success?  
      status.push "#{dep} ~#{old_ver}~ *#{new_ver}*"
    else
      status.push "#{dep} ~#{old_ver}~ *#{new_ver}* :boom:"

    end
end

puts status
