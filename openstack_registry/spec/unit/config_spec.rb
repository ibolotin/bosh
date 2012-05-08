# Copyright (c) 2009-2012 VMware, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::OpenStackRegistry do

  describe "configuring OpenStack registry" do
    it "reads provided configuration file and sets singletons" do
      Bosh::OpenStackRegistry.configure(valid_config)

      logger = Bosh::OpenStackRegistry.logger

      logger.should be_kind_of(Logger)
      logger.level.should == Logger::DEBUG

      Bosh::OpenStackRegistry.http_port.should == 25777
      Bosh::OpenStackRegistry.http_user.should == "admin"
      Bosh::OpenStackRegistry.http_password.should == "admin"

      db = Bosh::OpenStackRegistry.db
      db.should be_kind_of(Sequel::SQLite::Database)
      db.opts[:database].should == "/:memory:"
      db.opts[:max_connections].should == 433
      db.opts[:pool_timeout].should == 227
    end

    it "validates configuration file" do
      expect {
        Bosh::OpenStackRegistry.configure("foobar")
      }.to raise_error(Bosh::OpenStackRegistry::ConfigError,
                       /Invalid config format/)

      config = valid_config.merge("http" => nil)

      expect {
        Bosh::OpenStackRegistry.configure(config)
      }.to raise_error(Bosh::OpenStackRegistry::ConfigError,
                       /HTTP configuration is missing/)

      config = valid_config.merge("db" => nil)

      expect {
        Bosh::OpenStackRegistry.configure(config)
      }.to raise_error(Bosh::OpenStackRegistry::ConfigError,
                       /Database configuration is missing/)

      config = valid_config.merge("openstack" => nil)

      expect {
        Bosh::OpenStackRegistry.configure(config)
      }.to raise_error(Bosh::OpenStackRegistry::ConfigError,
                       /OpenStack configuration is missing/)
    end

  end
end
