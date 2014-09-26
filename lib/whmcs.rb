require 'whmcs/railtie'
require 'whmcs/configuration'
require 'curb'
require 'php_serialize'

module Whmcs
  autoload :Api, 'whmcs/api'

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
