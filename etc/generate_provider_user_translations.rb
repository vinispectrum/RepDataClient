# require "json"

# module ProviderUserTranslator
#   def self.run
#     result = []
#     translations_json = JSON.parse(File.read("../db/pure_spectrum_to_dalia_demographics.json"))


#       translations_json.each do |translation_unit|
#         if translation_unit["conditions"]
#         values = translation_unit["conditions"].map do |condition|
#           if condition["dalia_demographic_value"].is_a?(Array)
#             condition["dalia_demographic_value"].map do |value|
#               {
#                 "dalia_demographic_value" => value,
#                 "provider_user_demographic_value" => condition["condition_code"],
#                 "provider_user_demographic_key" => translation_unit["qualification_code"].to_s
#               }
#             end
#           else
#             {
#               "dalia_demographic_value" => condition["dalia_demographic_value"],
#               "provider_user_demographic_value" => condition["condition_code"],
#               "provider_user_demographic_key" => translation_unit["qualification_code"].to_s
#             }
#           end
#         end

#         if found = result.find {|item|item["dalia_demographic_key"] == translation_unit["dalia_demographic_key"]}
#           found["values"] = found["values"].concat(values.flatten).uniq
#         else
#           result << {
#             "dalia_demographic_key" => ((translation_unit["dalia_demographic_key"] == "device_kinds")? "device_kind" : translation_unit["dalia_demographic_key"]),
#             "values" => values.flatten
#           }
#         end

#       else
#         puts "No values for qualification #{translation_unit["qualification_code"]}"
#       end
#     end

#     File.write("provider_translations.json", JSON.pretty_generate(result))
#   end
# end


# ProviderUserTranslator.run
