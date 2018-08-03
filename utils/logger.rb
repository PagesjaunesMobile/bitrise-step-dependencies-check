def fail_with_message(message)
  puts "\e[31m#{message}\e[0m"
  exit(1)
end

def error_message(message)
  print "\e[31m#{message}\e[0m"
end