module RepDataClient
  class RequestError < StandardError
    attr_reader :api_request_details
    attr_reader :message

    def initialize(message, api_request_details)
      @message = message
      @api_request_details = api_request_details
    end
  end

  class TranslationMissingError < StandardError
    attr_accessor :qualification_code
    attr_accessor :condition_code

    def initialize(message, qualification_code, condition_code)
      @message = message
      @qualification_code = qualification_code
      @condition_code = condition_code
    end

    def to_s
      @message
    end
  end
end
