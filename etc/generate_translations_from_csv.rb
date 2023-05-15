# require "csv"
# require "json"
# module Translator
#   def self.run
#     translations_json = JSON.parse(File.read("../db/pure_spectrum_to_dalia_demographics.json"))

#     CSV.parse(File.read("translations.csv"), :headers => true).each do |row|
#       self.generate_translations_json(row, translations_json)
#     end
#   end

#   def self.generate_translations_json(row, result)
#     dalia_demographic_value = row["dalia_demographic_value"].gsub("(,)", "(.)")
#     dalia_demographic_value = dalia_demographic_value.include?(",") ? dalia_demographic_value.split(",") :  dalia_demographic_value

#     if dalia_demographic_value.is_a? Array
#       dalia_demographic_value.each {|v| v.gsub!("(.)", ",")}
#     else
#       dalia_demographic_value.gsub!("(.)", ",")
#     end

#     match = result.find {|element| element["qualification_code"].to_s == row["pure_spectrum_qualification_code"]}
#     if match
#       match["dalia_demographic_key"] = row["dalia_demographic_key"]
#       option_match = match["conditions"].find {|option| option["condition_code"] == row["pure_spectrum_option_code"]}
#       if option_match
#         if option_match["dalia_demographic_value"].is_a?(Array)
#           option_match["dalia_demographic_value"] << dalia_demographic_value unless option_match["dalia_demographic_value"].include?(dalia_demographic_value)
#         elsif option_match["dalia_demographic_value"].is_a?(String)
#           option_match["dalia_demographic_value"] = [option_match["dalia_demographic_value"], dalia_demographic_value] unless (option_match["dalia_demographic_value"] == dalia_demographic_value)
#         else
#           option_match["dalia_demographic_value"] = dalia_demographic_value
#         end
#       else
#         match["conditions"] << { "condition_code" => row["pure_spectrum_option_code"], "dalia_demographic_value" => dalia_demographic_value, "condition_text" => row["dalia_demographic_value"]}
#       end
#     else
#       result << {
#         "qualification_code" => row["pure_spectrum_qualification_code"].to_i,
#         "dalia_demographic_key" => row["dalia_demographic_key"],
#         "qualification_name" => row["dalia_demographic_key"],
#         "conditions" => [
#           { "condition_code" => row["pure_spectrum_option_code"], "dalia_demographic_value" => dalia_demographic_value, "condition_text" => row["dalia_demographic_value"]}
#         ]
#       }
#     end

#     result.each do |q|
#       if q["conditions"]
#         q["conditions"].each do |c|
#           c["dalia_demographic_value"].flatten! if c["dalia_demographic_value"].is_a?(Array)
#           c["dalia_demographic_value"].uniq! if c["dalia_demographic_value"].is_a?(Array)
#         end
#       end
#     end

#     File.write("translations_result.json", JSON.pretty_generate(result))
#   end
# end

# Translator.run
