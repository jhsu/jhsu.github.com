require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'github/markup'

class Resume

  class << self
    attr_accessor :data_dir
  end
  @data_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "../data"))

  def initialize(resume_file = 'resume.markdown')
    @resume_file = resume_file
    @resume_file_path = File.expand_path(File.join(self.class.data_dir, resume_file))
    @resume_content = File.read(@resume_file_path)
  end

  def file_path
    @resume_file_path
  end

  def text
    @resume_content
  end

  def latex
    doc = Maruku.new(@resume_content)
    doc.to_latex_document
  end

  def raw
    @resume_content
  end

  def to_html
    GitHub::Markup.render(@resume_file, raw)
  end

  def write_html_and_css_to_disk(root_path = '/tmp')
    base = File.join(File.dirname(__FILE__),'..')
    #root_path = File.join(base,root_path)
    #FileUtils.mkdir_p root_path unless File.exists?(root_path)
 
    parser = Less::Parser.new(:paths => [File.join(base, "views")], :filename => "style.less")
    tree = parser.parse(File.read('./views/style.less'))
    css = tree.to_css
    tmp_css = File.join(root_path, 'style.css')
    File.open(tmp_css, 'w') {|f| f.write(css) }

    resume = self
    title = "Resume"

    template = ERB.new(File.read(File.join(base, 'views/index.erb')))
    html = template.result(binding)

    tmp_file = File.join(root_path, 'index.html')
    File.open(tmp_file, 'w') {|f| f.write(html) }
    tmp_file
  end

  def open_html
    tmp_file = write_html_and_css_to_disk()
    Launchy::Browser.new.visit("file://"+File.expand_path(tmp_file))
  end

end
