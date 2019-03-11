#!rsc
# RouterOS script: update-ddns
#
# update ddns by issuing a fetch
#

:local token ""
:local domain ""

/tool fetch mode=https output=none url="https://freemyip.com/update?token=$token&domain=$domain"
