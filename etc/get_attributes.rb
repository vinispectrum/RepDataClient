# require "json"

# require_relative "../lib/pure_spectrum_client"

# pure_spectrum_client = PureSpectrumClient::Api.new(CONFIG[:production])
# qualification_code = ARGV[0]
# localization = ARGV[1]

# if !(qualification_code && localization)
#   puts "USAGE:"
#   puts "#=> ruby get_attributes.rb QUALIFICATION_CODE LOCALE"
#   exit
# end

# result = JSON.pretty_generate(pure_spectrum_client.get_attributes(qualification_code, localization))

# puts "Script result:"
# puts result
