module RepDataClient
  class Api
    attr_reader :config, :logger, :options

    def initialize(config, opts = {})
      @config = config

      @options = {
        :debug_mode => false
      }.merge!(opts)

      main_logger = options[:logger] || ::Logger.new(STDOUT)
      @logger = RepDataClient::Logger.new(main_logger, options[:debug_mode])

      logger.debug("Initalized with config:")
      logger.debug(config.inspect)

      logger.debug("Initalized with options:")
      logger.debug(options.inspect)
    end

    def get_surveys
      response_body = make_request("/surveys")
      JSON.parse(response_body)
    end

    def get_quotas(survey_id)
      response_body = make_request("/surveys//streams/#{survey_id}/quotas")
      JSON.parse(response_body)
    end

    def get_qualifications(survey_id)
      response_body = make_request("/surveys/streams/#{survey_id}/qualifications")
      JSON.parse(response_body)
    end

    def create_link(survey_id, body)
      response_body = make_request("/surveys/streams/#{survey_id}/link", :post, body)
      JSON.parse(response_body)
    end

    def update_link(survey_id, body)
      response_body = make_request("/surveys/streams/#{survey_id}/link", :post, body)
      JSON.parse(response_body)
    end

    def api_base_path
      return "https://stage-api.rdsecured.com/v2" if config[:environment] == "development"
      return "https://stage-api.rdsecured.com/v2" if config[:environment] == "staging"
      return "https://api.rdsecured.com/v2" if config[:environment] == "production"
    end

    def make_request(path, method = :get, query = {})
      path = "#{api_base_path}#{path}"
      response = nil

      logger.debug "Request:"
      logger.debug "-----------"
      logger.debug "url: #{path}"
      logger.debug "method: #{method}"
      logger.debug "query: #{query}"

      time =
        Benchmark.realtime do
          response =
            case method
              when :get then HTTPClient.get(path, query: query, headers: {"Content-Type" => "application/json", "access-token" => @config[:access_token]})
              when :post then HTTPClient.post(path, body: query, headers: {"Content-Type" => "application/json", "access-token" => @config[:access_token]})
              when :put then HTTPClient.put(path, body: query, headers: {"Content-Type" => "application/json", "access-token" => @config[:access_token]})
              when :delete then HTTPClient.delete(path, body: query, headers: {"Content-Type" => "application/json", "access-token" => @config[:access_token]})
            end
        end

      # HTTPClient (HTTParty) will automatically parse body if correct type was returned,
      # if its still a string - lets parse it manually
      if response.body.is_a? String
        begin
          response_body = JSON.parse(response.body)
          response_message = response.message
        rescue JSON::ParserError
          response_body = nil
          response_message = 'Error parsing response'
        end
      else
        response_body = response.body
        response.message = response.message
      end

      api_request_details = {
        :path => path,
        :url => response.request.last_uri,
        :query => query,
        :method => method,
        :time => "#{time * 1000} ms",
        :response_body => response_body,
        :response_code => response.code,
        :response_message => response_message
      }

      logger.debug "Api Request Details:"
      logger.debug "-------------"
      logger.debug JSON.pretty_generate(api_request_details)

      # Ignore API outage issues
      if [502, 503].include? response.code
        raise RepDataClient::RequestError.new('Provider API outage', api_request_details)
      elsif response.code != 200 or (response_body && (response_body["status"] == "failure"))
        message = response_body ? response_body["msg"].to_s : 'Response body cant be parsed as JSON'
        raise RepDataClient::RequestError.new(message, api_request_details)
      end

      response.body
    end
  end
end
