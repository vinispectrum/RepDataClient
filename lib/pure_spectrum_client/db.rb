# require "duplicate"

# module PureSpectrumClient::DB
#   STRICT_DEMOGRAPHICS = ['region_name', 'device_kinds', 'country_code', 'gender', 'age', 'postal_code', 'city_name']

#   def self.pure_spectrum_to_dalia_demographics_translator
#     @pure_spectrum_to_dalia_demographics_translator ||= JSON.parse(File.read("#{db_path}/pure_spectrum_to_dalia_demographics.json"))
#   end

#   def self.pure_spectrum_survey_localization_to_country_code(api_survey_basics)
#     api_survey_basics["surveyLocalization"].split("_")[1]
#   end

#   def self.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(qualification_code)
#     PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator.find { |e| e["qualification_code"] == qualification_code }
#   end

#   def self.translate_qualifications(qualifications, country_code, translator = nil)
#     _qualifications = Duplicate.duplicate(qualifications)

#     _qualifications.each do |qualification|
#       PureSpectrumClient::DB.translate_qualification!(qualification, country_code, translator)
#     end

#     _qualifications
#   end

#   def self.translate_quotas(quotas, country_code, translator = nil)
#     _quotas = Duplicate.duplicate(quotas)

#     _quotas.each do |quota|
#       PureSpectrumClient::DB.translate_quota!(quota, country_code, translator)
#     end

#     _quotas
#   end

#   def self.translate_quota!(quota, country_code, translator)
#     quota["criteria"].each do |qualification|
#       PureSpectrumClient::DB.translate_qualification!(qualification, country_code, translator)
#     end

#     quota
#   end

#   def self.translate_qualification!(qualification, country_code, translator)
#     qualification["qualification_code_translated"] = PureSpectrumClient::DB.pure_spectrum_qualification_code_to_pure_spectrum_name(qualification["qualification_code"])

#     if qualification["range_sets"] && qualification["qualification_code"] == 212
#       qualification_conditions = PureSpectrumClient::DB.calculate_age_values(qualification)
#     elsif qualification["range_sets"]
#       qualification_conditions = []
#     elsif qualification["qualification_code"] == 229
#       qualification_conditions = extract_and_normalize_postal_codes(qualification, country_code)
#     else
#       qualification_conditions = qualification["condition_codes"]
#     end

#     # We inject the DemographicsMapper translator as a dependency but we want the gem to be able
#     # to still work independently with the local jsons, at least for now.
#     translator ||= PureSpectrumClient::LocalTranslator

#     translator.translate_qualification_to_dalia_demographics(qualification, qualification_conditions)

#     qualification
#   end

#   def self.extract_and_normalize_postal_codes(qualification, country_code)
#     case(country_code)
#     when "CA"
#       qualification_conditions = qualification["condition_codes"].map { |code| code[0..2] }.uniq
#     when "GB"
#       qualification_conditions = qualification["condition_codes"].map do |code|
#         parsed_code = code[0..-4]
#         parsed_code = code if parsed_code.empty?
#         parsed_code
#       end.uniq
#     else
#       qualification_conditions = qualification["condition_codes"]
#     end

#     qualification_conditions
#   end

#   def self.qualification_conditions_to_dalia_demographic_value_is_same_value?(qualification_code)
#     result = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(qualification_code)
#     result ? result["same_value"] : false
#   end

#   def self.pure_spectrum_qualification_code_to_pure_spectrum_name(qualification_code)
#     result = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(qualification_code)
#     result ? result["qualification_name"] : "-- NO_TRANSLATION[#{qualification_code}] --"
#   end

#   def self.pure_spectrum_condition_code_to_dalia_demographic_value(qualification_code, condition_code)
#     translator_block = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(qualification_code)

#     unless translator_block
#       raise PureSpectrumClient::TranslationMissingError.new("Can't find translation for QualificationCode: #{qualification_code}, ConditionCode: #{condition_code}",
#                                                             qualification_code,
#                                                             condition_code)
#     end

#     qualification_conditions = translator_block["conditions"]

#     result = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_condition_code(condition_code, qualification_conditions)

#     result ? result["dalia_demographic_value"] : "no_translation"
#   end

#   def self.pure_spectrum_qualification_code_to_dalia_demographic_key(qualification_code)
#     result = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(qualification_code)
#     result ? result["dalia_demographic_key"] : nil
#   end

#   def self.calculate_age_values(qualification)
#     result = []
#     qualification["range_sets"].each do |range_set|
#       start_age = range_set["from"]
#       end_age = range_set["to"]

#       result << (start_age..end_age).to_a
#     end

#     result.flatten.sort
#   end

#   def self.translate_qualification_conditions(qualification_code, qualification_conditions)
#     result = []
#     pure_spectrum_to_dalia_demographics_translator_by_qualification_code = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(qualification_code)

#     qualification_conditions.each do |condition_code|
#       if pure_spectrum_to_dalia_demographics_translator_by_qualification_code
#         condition_with_translation = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_condition_code(condition_code, pure_spectrum_to_dalia_demographics_translator_by_qualification_code["conditions"])
#         condition_translated = condition_with_translation ?  condition_with_translation["condition_text"] : "-- NO_TRANSLATION[#{condition_code}] --"
#       else
#         condition_translated = "-- NO_TRANSLATION[#{condition_code}] --"
#       end

#       result << condition_translated
#     end

#     result
#   end

#   def self.calculate_dalia_target_groups(qualifications_translated, quotas_translated, country_code)
#     target_groups = []
#     base_target_qualifications = []

#     qualifications_translated = qualifications_translated.select {|qualification| qualification_is_supported?(qualification)}
#     base_target_qualifications << {"key" => "country_code", "values" => [country_code]}

#     # Creates the main target group
#     qualifications_translated.each do |qualification|
#       unless qualification["dalia_demographic_key"] == "device_kinds"
#         contents = { "key" => qualification["dalia_demographic_key"], "values" => qualification["dalia_demographic_values"].flatten.uniq.map { |value| value.to_s } }
#         # Mark flexible targets
#         contents.merge!({ "tolerance" => "flexible" }) if !is_demographic_strict?(qualification["dalia_demographic_key"])
#         base_target_qualifications << contents
#       end
#     end

#     if base_target_qualifications.empty?
#       return { "target_groups" => [], "quotas_not_supported" => [] }
#     end

#     target_groups << {
#         "id" => "main",
#         "target" => base_target_qualifications,
#         "required" => true
#      }

#     # Creates the target groups for each supported quotas
#     quotas_supported = quotas_translated.select { |quota| quota_is_supported?(quota)}
#     quotas_not_supported = quotas_translated.select { |quota| !quota_is_supported?(quota)}

#     quotas_supported.each do |quota|
#       if quota["criteria"]
#         target = PureSpectrumClient::DB.generate_target(quota["criteria"])

#         unless target.empty?
#           target_groups <<
#             {
#               "id" => quota["quota_id"],
#               "target" => target,
#               "amount_pending" => quota["quantities"]["currently_open"],
#             }
#         end
#       end
#     end

#     {
#       "target_groups" => target_groups,
#       "quotas_not_supported" => quotas_not_supported
#     }
#   end

#   def self.calculate_survey_groups(api_survey_basics)
#     api_survey_basics["survey_grouping"]["survey_ids"] || []
#   end

#   def self.translate_device_kind(qualifications)
#     result = []
#     device_kinds = qualifications.find {|e| e["qualification_code"] == 219}

#     return ["all"] unless device_kinds

#     result << "desktop" if device_kinds["condition_codes"].include?("111")
#     result << "mobile" if device_kinds["condition_codes"].include?("112")
#     result << "tablet" if device_kinds["condition_codes"].include?("113")

#     result = ["all"] if (result.size == 3 || result.size == 0)

#     result
#   end

#   def self.generate_target(qualifications)
#     result = []

#     qualifications.each do |qualification|
#       unless qualification["dalia_demographic_key"] == "device_kinds"
#         element_found = result.find { |entry| entry["key"] == qualification["dalia_demographic_key"] }

#         if element_found
#           element_found["values"].concat(qualification["dalia_demographic_values"].flatten).uniq!
#         else
#           contents = { "key" => qualification["dalia_demographic_key"], "values" => qualification["dalia_demographic_values"].flatten.uniq.map { |value| value.to_s } }
#           # Mark flexible targets
#           contents.merge!({ "tolerance" => "flexible" }) if !is_demographic_strict?(qualification["dalia_demographic_key"])
#           result << contents
#         end
#       end
#     end

#     result
#   end

#   def self.qualification_is_supported?(qualification)
#     !qualification["dalia_demographic_key"].nil?
#   end

#   def self.quota_is_supported?(quota)
#     quota["criteria"].all? {|qualification| qualification_is_supported?(qualification) }
#   end

#   def self.quota_is_still_open?(quota)
#     quota["quantities"]["remaining"] > 0
#   end

#   def self.is_demographic_strict?(demographic_key)
#     STRICT_DEMOGRAPHICS.include? demographic_key.to_s.downcase
#   end

#   def self.pure_spectrum_to_dalia_demographics_translator_by_condition_code(condition_code, qualification_conditions)
#     qualification_conditions.find { |e| e["condition_code"] == condition_code}
#   end

#   def self.calculate_qualifications_supported(qualifications_translated)
#     qualifications_translated
#       .select { |q| !q["dalia_demographic_key"].nil? }
#       .map { |q| PureSpectrumClient::DB.pure_spectrum_qualification_code_to_pure_spectrum_name(q["qualification_code"]) || "-- NO_TRANSLATION[#{qualification["qualification_code"]}] --" }
#   end

#   def self.calculate_qualifications_no_supported(qualifications_translated)
#     result = qualifications_translated.select { |q| q["dalia_demographic_key"].nil? }
#     result.map do |q|
#       qualification_code_translated = PureSpectrumClient::DB.pure_spectrum_qualification_code_to_pure_spectrum_name(q["qualification_code"])
#       (qualification_code_translated || "-- NO_TRANSLATION[#{qualification["qualification_code"]}] --")
#     end
#   end

#   def self.db_path
#     "#{File.dirname(__FILE__)}/../../db"
#   end
# end
