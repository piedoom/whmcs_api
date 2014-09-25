module Whmcs

  class Api
    include ActiveModel::Validations

    def execute_command!(command, params={})
      # Clear errors from previous request
      errors.clear

      # Set local variables
      @command = command.to_s
      @params = params.symbolize_keys


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
        curl.perform

        puts curl.body_str

        # handle response
        response = JSON.parse(curl.body_str, symbolize_names: true)
      rescue Exception => e
        # If error occurs, it adds to instance errors
        errors.add(:base, e.message)
        raise e
      end

      return response

      # # Checks if a command returns a Whmcs error. If error occurs,
      # # it adds to errors and excepions reises.
      # if response[:errorresponse].present?
      #   errors.add(:base, response[:errorresponse][:errortext])
      #   raise StandardError, response[:errorresponse][:errortext]
      # end
      #
      # result = response["#{command}response".downcase.to_sym]
      #
      # if result[:errortext].present?
      #   errors.add(:base, result[:errortext])
      #   raise StandardError, result[:errortext]
      # end
      #
      # # If all pass success, returns a result hash
      # result
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

    # Generates a signature for api request.
    # Details {Signing API Requests}[http://Whmcs.apache.org/docs/en-US/Apache_Whmcs/4.0.0-incubating/html/API_Developers_Guide/signing-api-requests.html]
    def sign_request(request_options)
      request_string = Hash[request_options.sort].to_query.downcase
      Base64.encode64(OpenSSL::HMAC.digest( OpenSSL::Digest.new('sha1'), Whmcs.config.secret_key, request_string)).strip
    end

    # Method provides shortcuts for api commands. For example
    # it can be called
    #   @api.list_virtual_machines!(parameters)
    # instead of
    #   @api.execute_command!('listVirtualMachines', parameters)
    #
    # It's useful in a command line mode. Function names will autocompletes.
    def attribute!(attr, *args)
      execute_command!(Whmcs.config.method_to_command(attr), *args)
    end

    # The same as #attribute! method, but calls #execute_command method,
    # which doesn't raise errors.
    def attribute(attr, *args)
      execute_command(Whmcs.config.method_to_command(attr), *args)
    end

    # Validates api command and parameters. Whmcs API specification
    # stores in a lib/config/api_spec.yml file. Method checks command name,
    # parameters names and required parameters presence.
    #
    # If command or parameters is invalid, then corresponding error will be
    # added to #errors
    def validate_api_params
      # validate command
      unless Whmcs.config.commands.include? @command
        errors.add(:command, "#{@command} is invalid command")
        return
      end

      # retrieve parameters that belongs
      allowed_params = Whmcs.config.command_params(@command)

      # each parameter name should be in allowed parameters for current command
      (@params.keys - allowed_params).each do |param|
        errors.add(:params, "'#{param}' parameter is not allowed")
      end

      # check required parameters
      required_params = Whmcs.config.command_required_params(@command)
      (required_params - @params.keys).each do |param|
        errors.add(:params, "'#{param}' parameter is required")
      end

      # # each parameter value should be a string
      # @params.each do |key,value|
      #   errors.add(:params, "'#{value}' parameter should be a String") unless value.is_a? String
      # end
    end

  end
end