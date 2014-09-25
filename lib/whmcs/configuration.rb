module Whmcs

  class Configuration

    attr_accessor :api_user,
                  :api_password,
                  :api_url,
                  :http_auth_user,
                  :http_auth_password

    def initialize
      if defined?(Rails) and File.exist?(File.expand_path('config/whmcs.yml', Rails.root))
        config = YAML.load_file(File.expand_path('config/whmcs.yml', Rails.root))[Rails.env]

        @api_user = config['api_user'] if config['api_user'].present?
        @api_password = config['api_password'] if config['api_password'].present?
        @api_url = config['api_url'] if config['api_url'].present?

        @http_auth_user = config['http_auth_user'] if config['http_auth_user'].present?
        @http_auth_password = config['http_auth_password'] if config['http_auth_password'].present?
      end
    end

  end
end

