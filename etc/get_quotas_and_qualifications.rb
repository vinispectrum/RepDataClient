# require "json"

# require_relative "../lib/pure_spectrum_client"

# pure_spectrum_client = PureSpectrumClient::Api.new(CONFIG[:staging])
# survey_id = ARGV[0]
# survey_id = 5398
# result = JSON.pretty_generate(pure_spectrum_client.get_quotas_and_qualifications(survey_id))

# puts "Script result:"
# puts result