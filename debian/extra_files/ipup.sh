#!/bin/sh
# Custom rules for Hotspot
# TRANS PROXY
#    ipt -I PREROUTING -t nat -p tcp -s 10.1.0.0/24 -d 10.1.0.1 --dport 3128 -j DROP
#    ipt -I PREROUTING -t nat -i $IF -p tcp -s 10.1.0.0/24 -d ! 10.1.0.1 --dport 80 -j REDIRECT --to 8080

    # Redirect to Squid proxy (drop direct attempts to proxy)
    ipt -I PREROUTING -t mangle -p tcp -s $NET/$MASK -d $ADDR --dport 3128 -j DROP
    ipt -I PREROUTING -t nat -i $TUNTAP -p tcp -s $NET/$MASK ! -d $ADDR --dport 80 -j REDIRECT --to 3128
    # Look at using this rule?
    # ipt -I PREROUTING  -t nat -i $TUNTAP -p tcp -s $NET/$MASK -d ! $ADDR --dport 80 -j DNAT --to 192.168.8.22:3128
    
    # Redirect DNS to local server # Coova Chilli seems to take care of this
#    ipt -I PREROUTING -t nat -i $TUNTAP -p tcp -s $NET/$MASK -d ! $ADDR --dport 53 -j REDIRECT --to 53
#    ipt -I PREROUTING -t nat -i $TUNTAP -p udp -s $NET/$MASK -d ! $ADDR --dport 53 -j REDIRECT --to 53    
# MASQUERADE
    ipt -I POSTROUTING -t nat -o $HS_WANIF -j MASQUERADE
