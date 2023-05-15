# module PureSpectrumClient
#   class LocalTranslator
#     def self.translate_qualification_to_dalia_demographics(qualification, qualification_conditions)
#       dalia_demographic_key = PureSpectrumClient::DB.pure_spectrum_qualification_code_to_dalia_demographic_key(qualification["qualification_code"])

#       same_value = PureSpectrumClient::DB.qualification_conditions_to_dalia_demographic_value_is_same_value?(qualification["qualification_code"])
#       (qualification["qualification_conditions_translated"] = same_value ? qualification_conditions : PureSpectrumClient::DB.translate_qualification_conditions(qualification["qualification_code"], qualification_conditions))

#       if dalia_demographic_key
#         qualification["dalia_demographic_key"] = dalia_demographic_key

#         if same_value
#           qualification["dalia_demographic_values"] = qualification_conditions
#         else
#           qualification["dalia_demographic_values"] = []

#           qualification_conditions.each do |condition_code|
#             dalia_demographic_value = PureSpectrumClient::DB.pure_spectrum_condition_code_to_dalia_demographic_value(qualification["qualification_code"], condition_code)
#             qualification["dalia_demographic_values"] << dalia_demographic_value
#           end
#         end
#       end
#     end
#   end
# end
