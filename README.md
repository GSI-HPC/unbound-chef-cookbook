Description
===========

This Chef cookbook will install and configure
an Unbound DNS server. The best strategy to
use this cookbook is calling it within a role.

The configurations provided are very barebones:
* a recursive caching DNS
* or a server with DNSSEC enabled

Configuring a recurisve caching DNS server is the 
default behaviour and no resolv.conf will be changed,
unless if requested by setting the proper attributes.

The DNS server configured will always listen to the 
loopback interface (by default).

Enabling a DNSSEC configuration will always exclude
the possibility of running Unbound as a cahing server.

Requirements
============

None specific.

Attributes
==========

`* node[:unbound][:forward_srv]`
`* node[:unbound][:interfaces]`
`* node[:unbound][:resolvconf]`
`* node[:unbound][:caching]`

By default 'caching' is set to true, so the
cookbook will always configure a caching DNS
server.

It is important to configure `forward_srv`
with one or more IP of DNS servers, which
will receive and answer the queries of the
local unbound server.

`interfaces` is used only if unbound
need to answer to queries coming from
other machines. By default, if left
unconfigured, the unbound server will
listen only on the loopback interface.

The `resolvconf` attribute needs to be
enabled only if the unbound server will 
be the main DNS server for the machine.
