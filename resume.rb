#!/usr/bin/env ruby
# A Sinatra app for displaying one's resume in multiple formats

require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'github/markup'

get '/' do
   resume = GitHub::Markup.render('resume.md', resume_data)
   erb :index, :locals => { :title => "Resume", :resume => resume, :formats => true }
end

get '/style.css' do
   content_type 'text/css', :charset => 'utf-8'
   less :style
end

get '/latex' do
  content_type 'application/x-latex'
  doc = Maruku.new(resume_data)
  doc.to_latex_document
end

get '/markdown' do
  content_type 'text/plain'
  resume_data
end

# note this only works if pdflatex is installed which is part of most LaTeX packages, but doesn't work on Heroku
# TODO if this ever works on heroku clean it up and add caching
get '/pdf' do
  # content_type 'application/x-latex'
  # pdf_file = 'tmp/resume.pdf'
  # latex_file = 'tmp/resume.tex'

  # return File.read(pdf_file) if File.exists?(pdf_file)
  # doc = Maruku.new(resume_data)
  # tex = doc.to_latex_document
  # File.open(latex_file, 'w') {|f| f.write(tex) }
  # `cd tmp && pdflatex resume.tex -interaction=nonstopmode` #'
  # File.read(pdf_file)
end

def resume_data
  File.read("data/resume.md")
end
