# require 'test_helper'

# class PureSpectrumClient::DBTest < Minitest::Test

#   def test_pure_spectrum_to_dalia_demographics_translator_by_qualification_code
#     result_1 = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(211)
#     result_2 = PureSpectrumClient::DB.pure_spectrum_to_dalia_demographics_translator_by_qualification_code(212)

#     assert_equal("gender", result_1["qualification_name"])
#     assert_equal("age", result_2["qualification_name"])
#   end

#   def test_pure_spectrum_qualification_code_to_pure_spectrum_name
#     result = PureSpectrumClient::DB.pure_spectrum_qualification_code_to_pure_spectrum_name(211)

#     assert_equal("gender", result)
#   end

#   def test_calculate_age_values
#     qualification = JSON.parse(read_fixture("qualification_age_range_values.json"))

#     result = PureSpectrumClient::DB.calculate_age_values(qualification)

#     expected_array = (20..45).to_a

#     assert_equal(expected_array, result)
#   end

#   def test_translate_qualification_conditions
#     result = PureSpectrumClient::DB.translate_qualification_conditions(211, ["111", "112"])

#     assert_equal("Male", result[0])
#     assert_equal("Female", result[1])
#   end

#   def test_pure_spectrum_condition_code_to_dalia_demographic_value
#     result = PureSpectrumClient::DB.pure_spectrum_condition_code_to_dalia_demographic_value(211, "112")

#     assert_equal("female", result)
#   end

#   def test_pure_spectrum_condition_code_to_dalia_demographic_value_raises_when_translation_missing
#     qualification_code = 000
#     condition_code = "3515316363161"
#     error = assert_raises PureSpectrumClient::TranslationMissingError do
#       PureSpectrumClient::DB.pure_spectrum_condition_code_to_dalia_demographic_value(qualification_code, condition_code)
#     end

#     assert_equal(error.qualification_code, 000)
#     assert_equal(error.condition_code, condition_code)
#     assert_equal(error.message, "Can't find translation for QualificationCode: #{qualification_code}, ConditionCode: #{condition_code}")
#   end

#   def test_pure_spectrum_condition_code_to_dalia_demographic_value_when_condition_code_is_missing
#     qualification_code = 1032
#     condition_code = "3515316363161"

#     assert_equal "no_translation", PureSpectrumClient::DB.pure_spectrum_condition_code_to_dalia_demographic_value(qualification_code, condition_code)
#   end

#   def test_pure_spectrum_qualification_code_to_dalia_demographic_key
#     result = PureSpectrumClient::DB.pure_spectrum_qualification_code_to_dalia_demographic_key(211)

#     assert_equal("gender", result)
#   end

#   def test_translate_qualifications
#     qualifications = JSON.parse(read_fixture("qualifications.json"))

#     result = PureSpectrumClient::DB.translate_qualifications(qualifications, "COUNTRY_CODE")
#     # write_fixture("qualifications_translated.json", result.to_json)

#     qualifications_translated = JSON.parse(read_fixture("qualifications_translated.json"))
#     assert_equal(qualifications_translated, result)
#   end

#   def test_translate_qualifications_for_canada
#     qualifications = JSON.parse(read_fixture("qualifications_ca_postcodes.json"))

#     result = PureSpectrumClient::DB.translate_qualifications(qualifications, "CA")
#     # write_fixture("qualifications_ca_postcodes_translated.json", result.to_json)

#     qualifications_translated = JSON.parse(read_fixture("qualifications_ca_postcodes_translated.json"))
#     assert_equal(qualifications_translated, result)
#   end

#   def test_translate_qualifications_for_gb
#     qualifications = JSON.parse(read_fixture("qualifications_gb_postcodes.json"))

#     result = PureSpectrumClient::DB.translate_qualifications(qualifications, "GB")
#     # write_fixture("qualifications_gb_postcodes_translated.json", result.to_json)

#     qualifications_translated = JSON.parse(read_fixture("qualifications_gb_postcodes_translated.json"))
#     assert_equal(qualifications_translated, result)
#   end

#   def test_translate_qualifications_with_multiple_values
#     qualifications = JSON.parse(read_fixture("qualifications_with_values.json"))

#     result = PureSpectrumClient::DB.translate_qualifications(qualifications, "COUNTRY_CODE")
#     # write_fixture("qualifications_with_values_translated.json", result.to_json)

#     qualifications_translated = JSON.parse(read_fixture("qualifications_with_values_translated.json"))
#     assert_equal(qualifications_translated, result)
#   end

#   def test_translate_quotas
#     quotas = JSON.parse(read_fixture("quotas.json"))

#     result = PureSpectrumClient::DB.translate_quotas(quotas, "COUNTRY_CODE")
#     # write_fixture("quotas_translated.json", result.to_json)

#     quotas_translated = JSON.parse(read_fixture("quotas_translated.json"))
#     assert_equal(quotas_translated, result)
#   end

#   def test_translate_quotas_deep_profiling
#     quotas = JSON.parse(read_fixture("quotas_deep_profiling.json"))

#     result = PureSpectrumClient::DB.translate_quotas(quotas, "COUNTRY_CODE")
#     # write_fixture("quotas_deep_profiling_translated.json", result.to_json)

#     quotas_translated = JSON.parse(read_fixture("quotas_deep_profiling_translated.json"))
#     assert_equal(quotas_translated, result)
#   end

#   def test_translate_quotas_for_canada
#     quotas = JSON.parse(read_fixture("quotas_ca_postcodes.json"))

#     result = PureSpectrumClient::DB.translate_quotas(quotas, "CA")
#     # write_fixture("quotas_ca_postcodes_translated.json", result.to_json)

#     quotas_translated = JSON.parse(read_fixture("quotas_ca_postcodes_translated.json"))
#     assert_equal(quotas_translated, result)
#   end

#   def test_translate_quotas_for_gb
#     quotas = JSON.parse(read_fixture("quotas_gb_postcodes.json"))

#     result = PureSpectrumClient::DB.translate_quotas(quotas, "GB")
#     # write_fixture("quotas_gb_postcodes_translated.json", result.to_json)

#     quotas_translated = JSON.parse(read_fixture("quotas_gb_postcodes_translated.json"))
#     assert_equal(quotas_translated, result)
#   end

#   def test_extract_and_normalize_postal_codes_for_ca
#     qualification = JSON.parse(read_fixture("qualifications_ca_postcodes.json")).find { |q| q["qualification_code"] == 229 }

#     assert_equal(
#       ["V5A", "V5B", "V5C"],
#       PureSpectrumClient::DB.extract_and_normalize_postal_codes(qualification, "CA")
#     )
#   end

#   def test_extract_and_normalize_postal_codes_bug
#     qualification = JSON.parse(read_fixture("qualification_postalcodes_short.json")).find { |q| q["qualification_code"] == 229 }

#     # write_fixture("qualification_postal_codes_short_translated.json", PureSpectrumClient::DB.extract_and_normalize_postal_codes(qualification, "GB"))

#     assert_equal(
#       JSON.parse(read_fixture("qualification_postal_codes_short_translated.json")),
#       PureSpectrumClient::DB.extract_and_normalize_postal_codes(qualification, "GB")
#     )
#   end

#   def test_extract_and_normalize_postal_codes_for_gb
#     qualification = JSON.parse(read_fixture("qualifications_gb_postcodes.json")).find { |q| q["qualification_code"] == 229 }

#     assert_equal(
#       ["M1", "LU5", "MK1", "MK9", "NN7", "MK10", "MK77", "HP22", "HP23", "NN12"],
#       PureSpectrumClient::DB.extract_and_normalize_postal_codes(qualification, "GB")
#     )
#   end

#   def test_pure_spectrum_survey_localization_to_country_code
#     api_survey_basics = JSON.parse(read_fixture("api_survey_basics_3387.json"))

#     assert_equal("US", PureSpectrumClient::DB.pure_spectrum_survey_localization_to_country_code(api_survey_basics))
#   end

#   def test_calculate_dalia_target_groups
#     qualifications_translated = JSON.parse(read_fixture("qualifications_translated.json"))

#     quotas_translated = JSON.parse(read_fixture("quotas_translated_for_target_groups.json"))
#     result = PureSpectrumClient::DB.calculate_dalia_target_groups(qualifications_translated, quotas_translated, "US")

#     # write_fixture("target_groups.json", result.to_json)

#     assert_equal(JSON.parse(read_fixture("target_groups.json")), result)
#   end

#   def test_flexible_target_groups
#     qualifications_translated = JSON.parse(read_fixture("qualifications_flexible_translated.json"))

#     quotas_translated = JSON.parse(read_fixture("quotas_translated_for_flexible_target_groups.json"))
#     result = PureSpectrumClient::DB.calculate_dalia_target_groups(qualifications_translated, quotas_translated, "US")

#     # write_fixture("felxible_target_groups.json", result.to_json)

#     assert_equal(JSON.parse(read_fixture("felxible_target_groups.json")), result)
#   end

#   def test_translate_device_kind
#     qualifications = JSON.parse(read_fixture("qualifications.json"))

#     assert_equal(["desktop", "mobile"], PureSpectrumClient::DB.translate_device_kind(qualifications))
#   end

#   def test_translate_device_kind_when_all_device_kinds
#     qualifications = JSON.parse(read_fixture("qualifications_all_device_kinds.json"))

#     assert_equal(["all"], PureSpectrumClient::DB.translate_device_kind(qualifications))
#   end
# end
