# Find IPv6 related facts for selected interfaces
if Facter.value(:interfaces)
  ifarray = Facter.value('interfaces').split(",")
  ifarray.each do |ifitem|
    if !ifitem.match("ns|tap|swp")
      ifreal = ifitem.dup
      ifitem.sub!('_', '.')
      Facter.add("ipaddress6_#{ifreal}") do
        setcode "ip addr show dev #{ifitem} scope global |grep inet6 |grep global |cut -d / -f 1 | awk -F\' \' \'{print $NF}\'"
      end
      Facter.add("netmask6_#{ifreal}") do
        setcode "ip addr show dev #{ifitem} scope global |grep inet6 |grep global |cut -d / -f 2  | cut -d \' \' -f 1"
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
      # create a fact that reference back to the original interface name
      Facter.add("interface_#{key}#{index}") do
        confine { Facter.value(:interfaces).split(',').include? iface }
        setcode { iface }
      end

      # set up interface aliases for these facts
      facts = %w(ipaddress macaddress mtu netmask network)

      facts.each do |fact|
        Facter.add("#{fact}_#{key}#{index}") do
          confine { !Facter.value("#{fact}_#{iface}").nil? }
          setcode { Facter.value("#{fact}_#{iface}") }
        end
      end
    end
  end
end
