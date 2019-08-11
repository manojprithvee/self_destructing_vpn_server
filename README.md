# self_destructing_vpn_server
1. create environment variables for digital ocean token, ipsec_psk, password and user as given seen in the code.
2. install droplet_kit
3. if on mac make sure you create a vpn named "vpn" and set all the username, password, ipsec_psk and give it a random address and save it
4. run vpn_create.rb this will create a vpn server in digital ocean and ask you for regions and self destructing time.
5. for mac users it will automatically change the ip address of the vpn and connect.
