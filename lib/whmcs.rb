module Whmcs
  require 'whmcs/railtie' if defined?(Rails)
  require 'whmcs/configuration'
  autoload :Api, 'whmcs/api'
  require 'curb'

  # Gives access to the current configuration
  def self.config
    @configuration ||= Configuration.new
  end

  # Allows easy setting of multiple configuration options. See Configuration
  # for all available options.
  def self.configure
    config = self.config
    yield(config)
  end
end
