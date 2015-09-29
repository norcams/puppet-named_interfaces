# read value of named_interfaces fact
if Facter.value(:named_interfaces)
  hash = Facter.value(:named_interfaces)

  hash.each_pair do |key,array|
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
