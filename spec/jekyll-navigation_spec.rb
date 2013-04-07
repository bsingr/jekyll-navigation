require 'spec_helper'
require 'yaml'

describe JekyllNavigation do
  let(:pages) { load_examples('pages') }

  shared_context 'level=root' do
    subject do
      described_class::Navigation.new({
        'page' => current_page,
        'site' => { 'pages' => pages } }, 'root')
    end
  end

  shared_context 'level=sub' do
    subject do
      described_class::Navigation.new({
        'page' => current_page,
        'site' => { 'pages' => pages } }, 'sub')
    end
  end

  context 'current_page=root' do
    let(:current_page) { build_current_page pages.find{|p| p.name == 'root.md'} }

    context 'level=root' do
      include_context 'level=root'

      its('display?') { should be_true }
      its('render') do
        should == "<li><a href=\"./root_lacks_config.html\">"\
                  "root_lacks_config</a></li>\n"\
                  "<li><a href=\"./root_level_with_sub.html\">"\
                  "root_level_with_sub</a></li>\n"\
                  "<li><a href=\"./root_level_without_sub.html\">"\
                  "root_level_without_sub</a></li>"
      end
    end

    context 'level=sub' do
      include_context 'level=sub'

      its('display?') { should be_false }
      its('render') { should == "" }
    end
  end

  context 'current_page=root_level_with_sub' do
    let(:current_page) { build_current_page pages.find{|p| p.name == 'root_level_with_sub.md'} }

    context 'level=root' do
      include_context 'level=root'

      its('display?') { should be_true }
      its('render') do
        should == "<li><a href=\"./root_lacks_config.html\">"\
                  "root_lacks_config</a></li>\n"\
                  "<li class='active'><a href=\"./root_level_with_sub.html\">"\
                  "root_level_with_sub</a></li>\n"\
                  "<li><a href=\"./root_level_without_sub.html\">"\
                  "root_level_without_sub</a></li>"
      end
    end

    context 'level=sub' do
      include_context 'level=sub'

      its('display?') { should be_true }
      its('render') { should == "<li><a href=\"./sub_level.html\">sub_level</a></li>" }
    end
  end

  context 'current_page=sub_level' do
    let(:current_page) { build_current_page pages.find{|p| p.name == 'sub_level.md'} }

    context 'level=root' do
      include_context 'level=root'

      its('display?') { should be_true }
      its('render') do
        should == "<li><a href=\"./root_lacks_config.html\">"\
                  "root_lacks_config</a></li>\n"\
                  "<li class='active'><a href=\"./root_level_with_sub.html\">"\
                  "root_level_with_sub</a></li>\n"\
                  "<li><a href=\"./root_level_without_sub.html\">"\
                  "root_level_without_sub</a></li>"
      end
    end

    context 'level=sub' do
      include_context 'level=sub'

      its('display?') { should be_true }
      its('render') do
        should == "<li class='active'><a href=\"./sub_level.html\">sub_level</a></li>"
      end
    end
  end

  describe 'navigation item' do
    context 'empty' do
      subject { described_class::AbstractNavigationItem.new 'name' => 'white.md' }
      its('title') { should == 'white' }
    end

    context 'title' do
      subject { described_class::AbstractNavigationItem.new 'name' => 'white.md',
                                           'title' => 'white like milk'}
      its('title') { should == 'white like milk' }
    end

    context 'title + navigation' do
      subject { described_class::AbstractNavigationItem.new 'name' => 'white.md',
                                           'title' => 'white like milk',
                                           'navigation' => {} }
      its('title') { should == 'white like milk' }
    end

    context 'title + navigation title' do
      subject { described_class::AbstractNavigationItem.new 'name' => 'white.md',
                                           'title' => 'white like milk',
                                           'navigation' => { 'title' => 'white like latte' } }
      its('title') { should == 'white like latte' }
    end

    context 'no parent' do
      subject { described_class::AbstractNavigationItem.new({}) }
      its('parent') { should be_nil }
    end

    context 'navigation + no parent' do
      subject { described_class::AbstractNavigationItem.new 'navigation' => {} }
      its('parent') { should be_nil }
    end

    context 'navigation parent' do
      subject { described_class::AbstractNavigationItem.new 'navigation' => { 'parent' => '/foo.html' } }
      its('parent') { should == '/foo.html' }
    end
  end
end
