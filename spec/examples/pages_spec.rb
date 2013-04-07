require 'spec_helper'

describe 'pages.yml' do
  subject { load_examples('pages') }

  its('size') { should > 1 }
  its('first.name') { should == 'root.md' }
  its('first.url') { should == '/root.html' }
  it { subject.first.data['navigation'].should == {'exclude' => true} }
end
