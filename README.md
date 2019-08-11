# Self Destructing Vpn Server
1. create environment variables for digital ocean api token as "DO_KEY", ipsec_psk as "VPN_IPSEC_PSK", password as "VPN_PASSWORD" and user as "VPN_USER" see the code for more details.
2. install droplet_kit
3. if on mac make sure you create a vpn of type l2tp over ipsec named "vpn" and set all the username, password, ipsec_psk and give it a random ip address and save it
4. run vpn_create.rb this will create a vpn server in digital ocean and ask you for regions and self destructing time.
5. for mac users it will automatically change the ip address of the vpn and connect. other users have to change ip address manually.
