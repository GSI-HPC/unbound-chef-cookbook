#
# Cookbook Name:: unbound
# Recipe:: default
#
# Copyright 2013 - 2014, Christopher Huhn
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

package 'resolvconf'
package 'unbound'

# pull the list of DNS root servers from the internet:
remote_file "/etc/unbound/root.hints" do
  #source "ftp://ftp.internic.net/domain/named.cache"
  source "http://192.0.32.9/domain/named.cache"
  # OSRN root servers:
  #source "http://www.orsn.org/roothint/"
end

insecure_domains = node[:unbound][:stub_zones].inject([]){ |a,(k,v)| a << k if v[:insecure]; a }

template '/etc/unbound/unbound.conf' do
  notifies :reload, 'service[unbound]'
  group 'unbound'
  mode 0640
  variables({
      :insecure_domains => insecure_domains,
      :stub_zones       => node[:unbound][:stub_zones]
    })
end

# drop a defauls file
template '/etc/default/unbound' do
  source 'unbound.default.erb'
  notifies :restart, 'service[unbound]'
end

service 'unbound' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
