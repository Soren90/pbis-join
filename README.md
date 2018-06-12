# pbis-join
This script will join AD and create AUTH and SUDO group for each node.

### Getting started
First you will need to download and install PBIS on your server:
https://github.com/BeyondTrust/pbis-open/releases



If you want to add a group for root access on all node, you need to add the following:

```
$ /opt/pbis/bin/adtool -a new-group --dn $DNPATH --pre-win-2000-name=ux_unix_admin --name=ux_unix_admin

```

### Troubleshooting

Use config dump to check your current settings:
```
$ /opt/pbis/bin/config --dump

```
