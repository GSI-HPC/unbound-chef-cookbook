
# By default the cookbook will configure the Unbound
# service as a caching DNS server:
default['unbound']['caching'] = true

# If set, the unbound init script will provide unbound's 
# listening IP addresses as nameservers to resolvconf.
default['unbound']['resolvconf'] = false

# Unbound listen interfaces (by default configured to
# listen only on the loopback address).
default['unbound']['interfaces'] = Array.new

# Unbound ACLs
default['unbound']['acls'] = []

# Support IPv6 (must be set to true to enable it).
default['unbound']['ipv6'] = nil

# IPs for the DNS forwarders:
default['unbound']['forward_srv'] = Array.new

# All the queries for the domains listed here will be
# directed toward specific DNS servers.
# The stub zones will be used only when Unbound is not
# configured as a caching DNS server.
default['unbound']['stub_zones']       = { }

# DNSSEC attributes:
default['unbound']['dnssec']['enable'] = false
default['unbound']['dnssec']['insecure_domains'] = [ ]
