# require "json"

# require_relative "../lib/pure_spectrum_client"

# pure_spectrum_client = PureSpectrumClient::Api.new(CONFIG[:staging])
# survey_id = ARGV[0]
# survey_id = 3388
# result = pure_spectrum_client.register_intent(survey_id)

# puts "Script result:"
# puts result.to_json