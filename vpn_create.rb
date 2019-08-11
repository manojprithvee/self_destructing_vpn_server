require 'droplet_kit'
require 'rbconfig'
token = ENV["DO_KEY"]
region = ["nyc1","nyc2","nyc3","ams2","ams3","sfo1","sfo2","sgp1","lon1","fra1","tor1","blr1"]
puts "which regions #{region.each_with_index.map{|value,index| "#{index+1}.#{value}"}.join(", ")} enter the number"
begin
  region_id = gets.to_i-1
  raise if region_id.nil?
  puts "server will be created in #{region[region_id]}"
rescue
  puts("error select correct region")
  retry
end
puts "how many hours do you want the server (caution: server will start shuting down 15 min early):"
begin
  hours = gets.to_i-1
  raise if hours.nil?
  raise if hours == -1
  hours = 1 if hours == 0
  puts "server will be created for #{hours} hours"
rescue
  puts("error select correct hours")
  retry
end
print "starting to create server"
min = (hours*60)-15
userdata = '#cloud-config
apt_update: false
write_files:
  - path: /root/vpn.env
    content: |
      VPN_IPSEC_PSK='+ENV["VPN_IPSEC_PSK"]+'
      VPN_USER='+ENV["VPN_USER"]+'
      VPN_PASSWORD='+ENV["VPN_PASSWORD"]+'
runcmd:
  - cd /root
  - docker run --name ipsec-vpn-server --env-file ./vpn.env --restart=always -p 500:500/udp -p 4500:4500/udp -d --privileged hwdsl2/ipsec-vpn-server
  - docker restart $(docker ps -q)
  - sleep '+min.to_s+'m && curl -X DELETE -H "Content-Type:application/json" -H "Authorization:Bearer '+token+'" "https://api.digitalocean.com/v2/droplets/`curl http://169.254.169.254/metadata/v1/id`"'
  
client = DropletKit::Client.new(access_token: token)
droplet_info = DropletKit::Droplet.new(
  name: 'vpn',
  region: region[region_id],
  size: 's-1vcpu-1gb',
  user_data: userdata,
  ssh_keys: [25137569],
  image:"docker-18-04",
  ipv6: true ,
  private_networking: true
)
droplet = client.droplets.create(droplet_info)
while droplet["status"] == "new"
droplet = client.droplets.find(id: droplet["id"])
print "."
end
ip = droplet[:networks]["v4"][0]["ip_address"]
print "waiting for server to config itself"
thread = Thread.new { while true do sleep 0.5;print "." end }
sleep 30
Thread.kill(thread)
`osascript changeconfig.applescript #{ip}` if RbConfig::CONFIG['host_os'].include?("darwin") or RbConfig::CONFIG['host_os'].include?("mac os")
puts "\nip====#{ip}"
