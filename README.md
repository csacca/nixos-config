# nixos-config

## Todo
```
localhost kernel: x86/cpu: SGX disabled by BIOS.
```

```
systemd-sysctl[705]: Couldn't write '60' to 'net/netfilter/nf_conntrack_generic_timeout', ignoring: No such file or directory
systemd-sysctl[705]: Couldn't write '1048576' to 'net/netfilter/nf_conntrack_max', ignoring: No such file or directory
systemd-sysctl[705]: Couldn't write '600' to 'net/netfilter/nf_conntrack_tcp_timeout_established', ignoring: No such file or directory
systemd-sysctl[705]: Couldn't write '1' to 'net/netfilter/nf_conntrack_tcp_timeout_time_wait', ignoring: No such file or directory
```

```
bootctl[942]: ! Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! !
bootctl[942]: ! Random seed file '/boot/loader/random-seed' is world accessible, which is a security hole! !
```

```
systemd-resolved[1045]: /etc/systemd/resolved.conf:11: Failed to parse DNS-over-TLS mode setting, ignoring: yes # or allow-downgrade
```

```
gdm-password][1701]: gkr-pam: unable to locate daemon control file
```