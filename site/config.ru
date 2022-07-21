require 'json'
require 'rack/app'
$:.unshift File.expand_path(__dir__ + '/../lib')

require 'great'

require 'erb'
require 'cgi'
class Page
  def initialize(filename, request_binding)
    @filename = filename
    @request_binding = request_binding
  end
  attr_reader :filename, :request_binding

  def file_path
    File.join(__dir__, filename)
  end

  def file_content
    content = File.open(file_path){|file|
      file.read
    }
  end

  def html
    file_content
  end

  def to_s
    ERB.new(html).result(request_binding)
  end
end

class GreatAgain < Rack::App
  include Great

  desc 'hello world endpoint'
  validate_params do
    required 'words',
      class: String,
      desc: 'text to be used for analysis',
      example: %w(vote for me)
  end

  get '/validated' do
    @great_text = Great(params['words'])
    @form = File.open('public/form.html'){|file| file.read }
    Page.new('result.erb', binding).to_s
  end
end

require 'utf8-cleaner'
use UTF8Cleaner::Middleware
use Rack::Static, :urls => {"/" => 'form.html'}, :root => 'public'

run GreatAgain
