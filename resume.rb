#!/usr/bin/env ruby
# A Sinatra app for displaying one's resume in multiple formats

require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'resume_gem'

def resume
  Resume.new
end

get '/' do
  erb :index, :locals => { :title => "Resume", :resume => resume, :formats => true }
end

get '/style.css' do
   content_type 'text/css', :charset => 'utf-8'
   less :style
end

get '/resume.markdown' do
  content_type 'text/x-markdown; charset=UTF-8'
  resume.raw
end

get '/resume.pdf' do
  content_type 'application/pdf'
  file = Gimli::MarkupFile.new(resume.file_path)
  c = Gimli::Converter.new([file], Gimli::Config.new)
  c.convert!
  File.read("./#{file.name}.pdf")
end

def resume_data
  File.read("data/resume.md")
end
