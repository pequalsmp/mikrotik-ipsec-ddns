#!rsc
# RouterOS script: update-ipsec-ddns-policies
#
# update ipsec addresses from ddns entries
#

# updates the ipsec proposal dst/src address
:local ipsecProposal "CHANGE_PROPOSAL_NAME"
 
:local ddnsDst "CHANGE_DESTINATION_DNS"
:local ddnsSrc "CHANGE_SOURCE_DNS"
 
:local ipDst [:resolve $ddnsDst]
:local ipSrc [:resolve $ddnsSrc]

:foreach policy in=[/ip ipsec policy find proposal="$ipsecProposal"] do={
    :local saDst [/ip ipsec policy get $policy sa-dst-address];
    :local saSrc [/ip ipsec policy get $policy sa-src-address];

    :if ($saDst != $ipDst) do={
        :log info "ipsec: sa-dst has changed from: $saDst to: $ipDst"
        /ip ipsec policy set $policy sa-dst-address="$ipDst";
    }

    :if ($saSrc != $ipSrc) do={
        :log info "ipsec: sa-src has changed from: $saSrc to: $ipSrc"
        /ip ipsec policy set $policy sa-src-address="$ipSrc";
    }
}

# update the ipsec peer address
:local peerName "CHANGE_PEER_NAME"

:local ipPeer [/ip ipsec peer get [find comment="$peerName"] address]
:local ipPeer [:pick "$ipPeer" 0 ([:len $ipPeer] - 3)]

:if ($ipPeer != $ipDst) do={
    :log info "ipsec: peer address has changed from: $ipPeer to: $ipDst"
    /ip ipsec peer set [find comment="$peerName"] address="$ipDst";
}

# update the firewall alias
:local aliasName "CHANGE_ALIAS_NAME"

:if ([:len [/ip fire address-list find address="$ipDst" and list="$aliasName"]] < 1) do={
    /ip firewall address-list add address=$ipDst list="$aliasName"
}
