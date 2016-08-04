# badIpRouteBlackhole
ip route blackhole bad IPs

## This is for blocking whole hosts through blackhole routes.

PRO:
   - Works on all kernel versions and as no compatibility problems (back to debian lenny and WAY further).
   - It's FAST for very large numbers of blocked ips.
   - It's FAST because it Blocks traffic before it enters common iptables chains used for filtering.
   - It's per host, ideal as action against ssh password bruteforcing to block further attack attempts.
   - No additional software required beside iproute/iproute2


CON:
   - Blocking is per IP and NOT per service, but ideal as action against ssh password bruteforcing hosts


Type can be blackhole, unreachable and prohibit. Unreachable and prohibit correspond to the ICMP reject messages.

[source] https://github.com/fail2ban/fail2ban/blob/5797ea0ae2932ed5f752508da1f49bd76356e537/config/action.d/route.conf
