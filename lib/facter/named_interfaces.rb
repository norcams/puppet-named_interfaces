# read value of named_interfaces fact
if Facter.value(:named_interfaces)

  hash = Facter.value(:named_interfaces)
  hash.each_pair do |key,array|
    hash[key].each.with_index(1) do |iface, index|

      # set up interface aliases for these facts
      facts = %w(ipaddress macaddress mtu netmask network)
      facts.each do |fact|
        if Facter.value("#{fact}_#{iface}")
          # Add a new fact using key and index as interface
          # The fact value is copied from the original interface
          Facter.add("#{fact}_#{key}#{index}") do
            setcode do
              Facter.value("#{fact}_#{iface}")
            end
          end
        end
      end

    end
  end

end
