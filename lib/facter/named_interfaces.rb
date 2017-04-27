# Find IPv6 related facts and CIDR for selected interfaces

ossystem = `uname -a | cut -d \' \' -f 1 | tr -d \'[:space:]\'`

if Facter.value(:interfaces)
  ifarray = Facter.value('interfaces').split(",")
  ifarray.each do |ifitem|
    if !ifitem.match("ns|tap|swp")
      ifreal = ifitem.dup
      ifreal.sub!('_', '.')
      Facter.add("ipaddress6_#{ifitem}") do
        setcode "ip addr show dev #{ifreal} scope global | grep inet6 |grep global | cut -d / -f 1 | awk -F\' \' \'{print $NF}\'"
      end
      Facter.add("netmask6_#{ifitem}") do
        setcode "ip addr show dev #{ifreal} scope global | grep inet6 |grep global | cut -d / -f 2 | cut -d \' \' -f 1"
      end
      if ossystem == "Linux"
        Facter.add("cidr_#{ifitem}") do
          setcode "ip addr show dev #{ifreal} | grep \'inet \' |grep global | cut -d / -f 2 | cut -d \' \' -f 1"
        end
      elsif ossystem == "FreeBSD"
        Facter.add("cidr_#{ifitem}") do
          setcode "ifconfig -f inet:cidr vtnet0 | grep \'inet \' | cut -d / -f 2 | cut -d \' \' -f 1"
        end
      end
    end
  end
end


# read value of named_interfaces fact
if Facter.value(:named_interfaces)
  hash = Facter.value(:named_interfaces)

  hash.each_pair do |key,array|
    # create a fact that returns an array of interfaces with this key
    Facter.add("#{key}_interfaces") do
      confine { !array.empty? }
      setcode { array }
    end

    hash[key].each.with_index(1) do |iface, index|
      modiface = iface.dup
      modiface.sub!('.', '_')
      # create a fact that reference back to the original interface name
      Facter.add("interface_#{key}#{index}") do
        confine { Facter.value(:interfaces).split(',').include? modiface }
        setcode { iface }
      end

      # set up interface aliases for these facts
      facts = %w(ipaddress ipaddress6 macaddress mtu netmask network netmask6 cidr)

      facts.each do |fact|
        Facter.add("#{fact}_#{key}#{index}") do
          confine { !Facter.value("#{fact}_#{modiface}").nil? }
          setcode { Facter.value("#{fact}_#{modiface}") }
        end
      end
    end
  end
end
