$:.unshift File.join(File.dirname(__FILE__), "lib")

require 'resume'
require 'resume/app'
run Resume::App
