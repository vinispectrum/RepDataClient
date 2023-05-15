# require "json"

# require_relative "../lib/pure_spectrum_client"

# config = {
#   :environment => "production",
#   :access_token => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU5MjQ1ZDg5YjA5MzRhNjI5OTdmMjBkMSIsInVzcl9pZCI6IjY2MSIsImlhdCI6MTQ5NTU1NTQ2NX0.R-Emzws6LxcD5rwQwxAN8IUTmpIqeKjs2NxolQbw3EQ"
# }

# client =
#   PureSpectrumClient::Api.new(
#     config,
#     {
#       :debug_mode => true
#     }
#   )

# surveys = client.get_surveys

# puts "Surveys: #{surveys}"