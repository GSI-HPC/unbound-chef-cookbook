require 'spec_helper'

describe command 'unbound-checkconf' do
  its(:exit_status) { should be_zero }
  its(:stderr) { should be_empty }
  its(:stdout) { should eq "unbound-checkconf: no errors in /etc/unbound/unbound.conf\n" }
end

describe service 'unbound' do
  it { should be_running }
end

describe command 'host www.gsi.de 127.0.0.1' do
  its(:exit_status) { should be_zero }
  its(:stderr) { should be_empty }
  its(:stdout) { should match %r{Using domain server:\nName: 127.0.0.1\nAddress: 127.0.0.1#53} }
  its(:stdout) { should match %r{^www\.gsi\.de has address 140\.181\.\d+\.\d+$} }
end
