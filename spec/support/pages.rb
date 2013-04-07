require 'yaml'

module PagesHelper
  def load_examples filename
    YAML.load_file("spec/examples/#{filename}.yml").map do |name, data|
      build_page name, data
    end
  end

  def build_page name, data
    url = '/' + File.basename(name, File.extname(name)) + '.html'
    page = double('page')
    page.stub(:name).and_return(name)
    page.stub(:url).and_return(url)
    page.stub(:[]).and_return do |key|
      data[key]
    end
    page.stub(:data).and_return(data)
    page
  end

  def build_current_page page
    data = page.data.dup.merge('url' => page.url)
    current_page = double('current_page')
    current_page.stub(:[]).and_return do |key|
      data[key]
    end
    current_page.stub(:data).and_return(data)
    current_page
  end
end

RSpec.configure do |config|
  config.include(PagesHelper)
end
