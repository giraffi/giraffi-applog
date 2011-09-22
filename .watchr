watch('test/test_.*\.rb') do |m| 
  system("ruby #{m[0]}")
end

watch('lib/(.*)\.rb') do |m|
  system("ruby test/test_#{m[1]}.rb")
end
