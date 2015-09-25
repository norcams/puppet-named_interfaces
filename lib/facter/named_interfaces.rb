# read hash from named_interfaces fact
hash = Facter.value(:named_interfaces)

# set up interface aliases for these facts
facts = %w(ipaddress macaddress mtu netmask network)

hash.each_pair do |key,array|
  hash[key].each.with_index(1) do |iface, index|
    facts.each do |fact|
      if Facter.value("#{fact}_#{iface}")
        Facter.add("#{fact}_#{key}#{index}") do
          setcode do
            Facter.value("#{fact}_#{iface}")
          end
        end
      end
    end
  end
end
