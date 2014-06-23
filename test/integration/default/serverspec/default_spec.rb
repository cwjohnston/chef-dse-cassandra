require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe service('dse') do
  it { should be_running }
end
