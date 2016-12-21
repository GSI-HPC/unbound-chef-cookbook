#
# Cookbook Name:: unbound
# Recipe:: default
#
# Author:: Christopher Huhn
# Author:: Matteo Dessalvi
#
# Copyright 2013 - 2016, GSI HPC department
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

if node[:unbound][:resolvconf]
  package 'resolvconf'
end

apt_package 'unbound' do
  default_release 'wheezy-backports' if node['lsb']['codename'] == 'wheezy'
end


# Ship the general Unbound config file (it will just include any
# configuration under /etc/unbound/unbound.conf.d/*.conf).
cookbook_file "unbound_main" do
  source "unbound.conf"
  path "/etc/unbound/unbound.conf"
  action :create
end

# create the directory for config snippets:
directory '/etc/unbound/unbound.conf.d'

if node[:unbound][:dnssec][:enable]
  # these are obtained from the stub_zones...
  insecure_domains = node[:unbound][:stub_zones].inject([]){ |a,(k,v)| a << k if v[:insecure]; a }

  template '/etc/unbound/unbound.conf.d/dnssec-root-auto-trust-anchor-file.conf' do
    source 'unbound_server.conf.erb'
    notifies :restart, 'service[unbound]'
    group 'unbound'
    mode 0640
    variables({
        :ipv6 => node[:unbound][:ipv6],
        :insecure_domains => insecure_domains,
        :stub_zones       => node[:unbound][:stub_zones]
              })
  end
end

# configure a DNS caching server:
if node[:unbound][:caching]
  template '/etc/unbound/unbound.conf.d/recursive-caching-dns.conf' do
    source 'unbound_server.conf.erb'
    notifies :restart, 'service[unbound]'
    group 'unbound'
    mode 0640
    variables(
      forwarders: node['unbound']['forward_srv'],
      ipv6:       node['unbound']['ipv6'],
      acls:       node['unbound']['acls']
    )
  end
end

# drop a Debian default file
template '/etc/default/unbound' do
  source 'unbound.default.erb'
  notifies :restart, 'service[unbound]'
end

service 'unbound' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
