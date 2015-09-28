#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What named_interfaces affects](#what-named_interfaces-affects)
    * [Setup requirements](#setup-requirements)
    * [Usage](#usage)
5. [Limitations](#limitations)

## Overview

Use abstract names for network related fact values. Map use of `$ipaddress_eth1` to a higher layer in your code using the more descriptive `$ipaddress_public1`

## Module Description

When writing Puppet code handling network interfaces and ipaddresses it makes sense to use the network-related facts from Facter as configuration values. Over time this could lead to your code becoming too static in places. If you reference the eth1-related facts in your code and templates, you would later need to update that code if you need to change to a different interface.

This module sets up additional aliased network-related facts so that you can use abstract interface naming in your code.

Given this configuration hash

```yaml
mgmt:
  - eth1
public:
  - eth2
  - eth3
```

additional facts will be created that maps 

* `$ipaddress_mgmt1` to the value of `$ipaddress_eth1` if it exists
* `$ipaddress_public1` to the value of `$ipaddress_eth2` if it exists
* `$ipaddress_public2` to the value of `$ipaddress_eth3` if it exists

Interface aliases are indexed starting from 1. The same logic as above will apply to the other interface-related facts, e.g `$network_mgmt1` will also be available.

## Setup

### What named_interfaces affects

* By default, the module will create and manage the `/etc/facter` and `/etc/facter/facts.d` folders.
* On the first run, a structured external fact `$named_interfaces` is created as `/etc/facter/facts.d/named_interfaces.yaml`
* If pluginsync is enabled, additional aliased facts will be available for the next run.

### Setup requirements

Pluginsync needs to be enabled for the custom facts to become available.

To enable using a Hiera deep merged config hash for this module, create a `named_interfaces` hash key in your Hiera configuration. This key will be used if no data is found during automatic priority lookup of `named_interfaces::config`

Developed using Puppet 3.8.x

### Usage

To start using the module, use:

```puppet
include named_interfaces
```

To pass a config hash as a variable, not manage the facter configuration directories, and use resource-like syntax (turning off automatic Hiera lookups):

```puppet
class { 'named_interfaces':
  config            = $data::named_interfaces,
  manage_facterdirs = false,
}
```

## Limitations

None known.

