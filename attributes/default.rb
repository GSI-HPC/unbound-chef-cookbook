
# All the queries for the domains listed here will be
# directed toward specific DNS servers.
default[:unbound][:stub_zones]       = { }

# DNSSEC attributes:
default[:unbound][:dnssec][:enable] = false
default[:unbound][:dnssec][:insecure_domains] = [ ]

