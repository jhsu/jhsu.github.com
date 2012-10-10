class Resume::App < Sinatra::Base
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
end
