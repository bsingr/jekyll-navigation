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
    subject(:item) { described_class::AbstractNavigationItem.new({}) }

    describe 'title' do
      subject { item.title }

      context 'empty' do
        before { item.page = {'name' => 'white.md'} }
        it { should == 'white' }
      end

      context 'title' do
        before { item.page = {'name' => 'white.md',
                              'title' => 'white like milk'} }
        it { should == 'white like milk' }
      end

      context 'title + navigation' do
        before { item.page = { 'name' => 'white.md',
                               'title' => 'white like milk',
                               'navigation' => {}} }
        it { should == 'white like milk' }
      end

      context 'title + navigation title' do
        before { item.page = {'name' => 'white.md',
                              'title' => 'white like milk',
                              'navigation' => {
                                'title' => 'white like latte' }} }
        it { should == 'white like latte' }
      end
    end

    describe 'parent' do
      subject { item.parent }
      
      context 'no parent' do
        before { item.page = {} }
        it { should be_nil }
      end

      context 'navigation + no parent' do
        before { item.page = {'navigation' => {}} }
        it { should be_nil }
      end

      context 'navigation parent' do
        before { item.page = {'navigation' => {
                                'parent' => '/foo.html' }} }
        it { should == '/foo.html' }
      end
    end

    describe 'order' do
      subject { item.order }
      
      context 'no order' do
        before { item.page = {} }
        it { should == -1 }
      end

      context 'navigation + no order' do
        before { item.page = {'navigation' => {}} }
        it { should == -1 }
      end

      context 'navigation order' do
        before { item.page = {'navigation' => {
                                'order' => 3 }} }
        it { should == 3 }
      end
    end

    describe 'exclude?' do
      subject { item.exclude? }
      
      context 'no exclude' do
        before { item.page = {} }
        it { should be_false }
      end

      context 'navigation + no exclude' do
        before { item.page = {'navigation' => {}} }
        it { should be_false }
      end

      context 'navigation exclude' do
        before { item.page = {'navigation' => {
                                'exclude' => true }} }
        it { should be_true }
      end
    end
  end
end
