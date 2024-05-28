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
      File[$named_interfaces::facts_d] -> File[$named_interfaces::fact_file]
    }

    # FIXME: change to stdlib::to_yaml for stdlib version > 8
    file { $named_interfaces::fact_file:
      ensure  => present,
      content => to_yaml('named_interfaces' => $named_interfaces::interfaces),
    }

  }

}
