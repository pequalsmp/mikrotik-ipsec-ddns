# What is this?

This is a hack-ish work-around for an IPsec setup with dynamic ips  where one (or both) of the devices are running RouterOS.

- `update-ddns` - the script calls the `freemyip` API in order to update the A record
- `update-ipsec-ddns-entries` - this script changes all SA / peer addresses and adds the remote tunnel's address to a firewall list (optional)

# Prerequisites

- IPsec policies must use the same proposal (for each SA) and this proposal should not be used by any other peer/tunnel (even if the settings are similar just create a new one)
- IPsec peer must have a unique comment (to be used as identifier/name)

# Initial setup

1. Open `update-ddns.rsc` and chage the corresponding `token` and `domain`.

Note: this is not universal and it currently works only for `freemyip.com`. You should change the script to match your ddns provider.

2. Open `update-ipsec-ddns-entries.rsc` and configure each `CHANGE_` entry.

- `ipsecProposal` - IPsec proposal name, that you want to update
- `ddnsDst` - fqdn of the remote side of the tunnel (flip if both sides are running routeros)
- `ddnsSrc` - fqdn of the local side of the tunnel
- `peerName` - comment of the peer you wish to update
- `aliasName` - firewall alias that you may want to add remote tunnel ip addresses to

# RouterOS setup

1. Create a new script (with a name of your chosing) via `System -> Scripts` and give it `read` and `test` permissions.
2. Copy the contents of the `update-ddns.rsc` file in the `Source` field.

3. Create a new script (with a name of your chosing) via `System -> Scripts` and give it `read`, `policy`, `sensitive`, `write` and `test` permissions.
4. Copy the contents of the `update-ipsec-ddns-entries.rsc` file in the `Source` field.

5. Create a new event (with a name of your chosing) via `System -> Scheduler`, give it permissions `read`, `test` and enter the name you chose (in step 1) for your script in the `On Event` field.

Note: be careful, ddns providers usually have limits for updates

6.  Create a new event (with a name of your chosing) via `System -> Scheduler`, give it permissions `read`, `policy`, `sensitive`, `write`, `test` and enter the name (in step 2) you chose for your script in the `On Event` field.

Note: Frequent updates are not a problem as the script queries DNS names and updates the settings only  when necessary.
