# Copyright (c) 2009-2012 VMware, Inc.

module Bosh::OpenStackRegistry::Models
  class OpenStackServer < Sequel::Model

    def validate
      validates_presence [:server_id, :settings]
      validates_unique :server_id
    end

  end
end