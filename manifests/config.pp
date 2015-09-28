# == Class named_interfaces::config
#
# Sets up an external structured fact $named_interfaces
#
class named_interfaces::config {

  unless empty($named_interfaces::interfaces) {

    if $named_interfaces::manage_facterdirs {
      file { [$named_interfaces::facter_root,
              $named_interfaces::facts_d]:
        ensure => directory,
      }
      File[$named_interfaces::facts_d] -> Hash_file[$named_interfaces::fact_file]
    }

    hash_file { $named_interfaces::fact_file:
      value    => {
        'named_interfaces' => $named_interfaces::interfaces,
      },
      provider => 'yaml',
    }

  }

}
