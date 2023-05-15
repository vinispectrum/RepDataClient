require 'dotenv'
Dotenv.load

CONFIG = {
  :test => {
    :environment => "staging",
    :access_token => "TOKEN",
    :debug_mode => false
  },

  :staging => {
    :environment => "staging",
    :access_token => ENV['DALIA_SECRET_REP_DATA_API_ACCESS_TOKEN'],
    :debug_mode => true
  },

  :production => {
    :environment => "production",
    :access_token => ENV['DALIA_SECRET_REP_DATA_API_ACCESS_TOKEN'],
    :debug_mode => false
  }
}
