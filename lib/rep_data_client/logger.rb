module RepDataClient
  class Logger
    attr_reader :logger, :debug_mode

    def initialize(logger, debug_mode = true)
      @logger = logger
      @debug_mode = debug_mode
    end

    def debug(message)
      return unless debug_mode

      logger.info "RepDataClient: [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}]: #{message}"
    end
  end
end