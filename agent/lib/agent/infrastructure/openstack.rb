# Copyright (c) 2009-2012 VMware, Inc.

module Bosh::Agent
  class Infrastructure::OpenStack
    require 'sigar'
    require 'agent/infrastructure/openstack/settings'
    require 'agent/infrastructure/openstack/registry'

    def load_settings
      Settings.new.load_settings
    end

    def get_network_settings(network_name, properties)
      Settings.new.get_network_settings(network_name, properties)
    end

  end

  # Alias for Bosh::Agent::Infrastructure.infrastructure method
  class Infrastructure::Openstack
    Infrastructure::OpenStack
  end
end
