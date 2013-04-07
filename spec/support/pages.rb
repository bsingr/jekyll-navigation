require 'yaml'

module PagesHelper
  def load_examples filename
    YAML.load_file("spec/examples/#{filename}.yml").map do |name, data|
      url = '/' + File.basename(name, File.extname(name)) + '.html'
      page = double('page')
      page.stub(:name).and_return(name)
      page.stub(:url).and_return(url)
      page.stub(:data).and_return(data)
      page
    end
  end
end

RSpec.configure do |config|
  config.include(PagesHelper)
end
