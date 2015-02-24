
# By default the cookbook will configure the Unbound
# service as a caching DNS server:
default[:unbound][:caching] = true

# IPs for the DNS forwarders:
default[:unbound][:forward_srv] = Array.new

# All the queries for the domains listed here will be
# directed toward specific DNS servers.
# The stub zones will be used only when Unbound is not
# configured as a caching DNS server.
default[:unbound][:stub_zones]       = { }

# DNSSEC attributes:
default[:unbound][:dnssec][:enable] = false
default[:unbound][:dnssec][:insecure_domains] = [ ]

