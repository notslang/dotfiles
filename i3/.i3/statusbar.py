from i3pystatus import Status

status = Status(standalone=True)

# ISO 8601 format
status.register('clock', format='%Y-%m-%d %H:%M:%S')

# average load over the last minute and the last 5 minutes
status.register('load')

status.register('mem', divisor=1024**3,
                format='ram {used_mem}/{total_mem}G [{avail_mem}G]')

for mount_point in ('/', '~/proj', '/usrdata', '/archive'):
    status.register('disk', path=mount_point.replace('~/', '/home/slang/'),
                    format=mount_point + ' {used}/{total}G [{avail}G]')

# Shows the address and up/down state of eth0. If it is up the address is shown
# in green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24). If it's down just the interface name (eth0) will be
# displayed in red (defaults of format_down and color_down).
# Note: the network module requires PyPI package netifaces
NETWORK_FORMAT = "{bytes_sent}MB/s⬆ {bytes_recv}MB/s⬇ IPv4: {v4cidr}, IPv6: \
{v6cidr}"
status.register('network', divisor=1048576, round_size=2,
                interface='enp7s0', format_up=NETWORK_FORMAT)

status.run()
