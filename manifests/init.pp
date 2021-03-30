# == Class: named_interfaces
#
# This module creates a YAML file /etc/facter/facts.d/named_interfaces.yaml
# to provide a custom fact $named_interfaces
#
# The module will also create additional facts based on the named interfaces
# you configure. This allows you to use abstract interface names in Puppet
# code and Hiera data so that e.g switching interfaces or IP addresses are
# easier.
#
# === Parameters
#
# [*config*]
#   Config hash specifying a named_interfaces configuration, e.g
#
#     {"mgmt"=>["eth1"], "transport"=>["eth2", "eth3"]}
#
#   This configuration will make additional network facts available, e.g
#
#   ipaddress_mgmt1 will resolve to ipaddress_eth1
#   macaddress_mgmt1 will resolve to macaddress_eth1
#   netmask_transport2 will resolve to netmask_eth3
#
# [*facter_root*]
#   Facter configuration folder. Defaults to /etc/facter
#
# [*facts_d*]
#   Full path to the facts.d folder, normally inside facter_root. Defaults to
#   /etc/facter/facts.d
#
# [*fact_file*]
#   Full path of the file that will contain the YAML-format $named_interfaces
#   fact. Defaults to /etc/facter/facts.d/named_interfaces.yaml
#
# [*manage_factdirs*]
#   Manage and create facter_root and facts_d directories if they don't exist
#   Defaults to true.
#
class named_interfaces (
  $config            = {},
  $facter_root       = '/etc/facter',
  $facts_d           = '/etc/facter/facts.d',
  $fact_file         = '/etc/facter/facts.d/named_interfaces.yaml',
  $manage_facterdirs = true,
) {
  validate_legacy(Boolean, 'validate_bool', $manage_facterdirs)

  $interfaces = empty($config) ? {
    false   => $config,
    default => hiera_hash('named_interfaces', {}),
  }

  # validate data
  validate_legacy(Hash, validate_hash, $interfaces)

  contain 'named_interfaces::config'
}
