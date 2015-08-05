module Whmcs

  class Api
    include ActiveModel::Validations

    def execute_command!(command, params={})
      # Clear errors from previous request
      errors.clear

      # Set local variables
      @command = command.to_s
      @params = process_params(params)


      # Assemble request_options
      request_options = {
          action: @command,
          username: Whmcs.config.api_user,
          password: Digest::MD5.hexdigest(Whmcs.config.api_password),
          responsetype: 'json'
      }
      request_options.merge! @params

      begin
        # send curl request to the Whmcs server
        curl = Curl::Easy.new(Whmcs.config.api_url)
        curl.ssl_verify_peer = false
        curl.ssl_verify_host=0
        if Whmcs.config.http_auth_user.present?
          curl.http_auth_types = :basic
          curl.username = Whmcs.config.http_auth_user
          curl.password = Whmcs.config.http_auth_password
        end
        curl.http_post(request_options.to_query)
        
        #should fix errors
        #curl.perform

        # handle response
        result = JSON.parse(curl.body_str, symbolize_names: true)
      rescue Exception => e
        # If error occurs, it adds to instance errors
        errors.add(:base, e.message)
        raise e
      end

      # check if error occurred
      if result[:result] == 'error'
        errors.add(:base, result[:message])
        raise StandardError, result[:message]
      end

      # If all pass success, returns a result hash
      result
    end

    # Method provides the same functionality as #execute_command! except
    # it does not raises exceptions. When error occurs, it just returns +false+.
    # So if method returns +false+, errors message should be in #errors
    #
    # == Example
    #
    #   @api = Whmcs::Api.new
    #   @api.execute_command('some command', some_param: 'some value')   # => false
    #   @api.errors.messages # => {:command=>["'some command' is invalid command"]}
    #

    def execute_command(command, options={})
      begin
        return execute_command!(command, options)
      rescue
        return false
      end
    end

    protected

    # converts params keys to symbols, joins array values and encodes hashes
    def process_params(options)
      options = options.clone
      options.each do |key, value|
        options[key] = value.join(',') if value.is_a?(Array)
        options[key] = Base64.encode64(PHP.serialize(value)) if value.is_a?(Hash)
      end
    end

  end
end
