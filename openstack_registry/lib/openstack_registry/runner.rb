# Copyright (c) 2009-2012 VMware, Inc.

module Bosh::OpenStackRegistry
  class Runner
    include YamlHelper

    def initialize(config_file)
      Bosh::OpenStackRegistry.configure(load_yaml_file(config_file))

      @logger = Bosh::OpenStackRegistry.logger
      @http_port = Bosh::OpenStackRegistry.http_port
      @http_user = Bosh::OpenStackRegistry.http_user
      @http_password = Bosh::OpenStackRegistry.http_password
    end

    def run
      @logger.info("BOSH OpenStack Registry starting...")
      EM.kqueue if EM.kqueue?
      EM.epoll if EM.epoll?

      EM.error_handler { |e| handle_em_error(e) }

      EM.run do
        start_http_server
      end
    end

    def stop
      @logger.info("BOSH OpenStack Registry shutting down...")
      @http_server.stop! if @http_server
      EM.stop
    end

    def start_http_server
      @logger.info "HTTP server is starting on port #{@http_port}..."
      @http_server = Thin::Server.new("0.0.0.0", @http_port, :signals => false) do
        Thin::Logging.silent = true
        map "/" do
          run Bosh::OpenStackRegistry::ApiController.new
        end
      end
      @http_server.start!
    end

    private

    def handle_em_error(e)
      @logger.send(level, e.to_s)
      if e.respond_to?(:backtrace) && e.backtrace.respond_to?(:join)
        @logger.send(level, e.backtrace.join("\n"))
      end
      stop
    end

  end
end