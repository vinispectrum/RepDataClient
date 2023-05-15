# require "test_helper"

# class PureSpectrumClient::ApiTest < Minitest::Test
#   def setup
#     FakeWeb.allow_net_connect = false
#     @client = PureSpectrumClient::Api.new(CONFIG[:test])
#   end

#   def test_get_surveys
#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/surveys",
#       :body => read_fixture("get_surveys.json"),
#       :content_type => "application/json",
#       :status => ["200", "Success"]
#     )

#     result = @client.get_surveys
#     assert_equal(3384, result.first["survey_id"])
#   end

#   def test_get_surveys_when_no_survey
#     response_body = {
#       "apiStatus" => "success",
#       "msg" => "No survey record found"
#     }.to_json

#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/surveys",
#       :body => response_body,
#       :content_type => "application/json",
#       :status => ["200", "Success"]
#     )

#     result = @client.get_surveys
#     assert_equal([], result)
#   end

#   def test_get_exclusion_list
#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/surveys/3388/PSIDRef",
#       body: read_fixture("get_exclusion_list.json"),
#       content_type: "application/json",
#       status: ["200", "Success"]
#     )

#     result = @client.get_exclusion_list(3388)
#     assert_equal(5, result['PSIDRef'].count)
#   end

#   def test_get_attributes
#     response_body = {
#       "apiStatus" => "success",
#       "msg" => "attributes"
#     }.to_json

#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/attributes/QUALIFICATION_CODE?localization=LOCALIZATION&format=true",
#       :body => response_body,
#       :content_type => "application/json",
#       :status => ["200", "Success"]
#     )

#     result = @client.get_attributes("QUALIFICATION_CODE", "LOCALIZATION")
#     assert_equal("attributes", result["msg"])
#   end

#   def test_get_quotas_and_qualifications
#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/surveys/3388",
#       :body => read_fixture("get_quotas_and_qualifications.json"),
#       :content_type => "application/json",
#       :status => ["200", "Success"]
#     )

#     result = @client.get_quotas_and_qualifications(3388)
#     assert_equal(3388, result["survey"]["survey_id"])
#   end

#   def test_register_intent
#     FakeWeb.register_uri(
#       :post,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/surveys/register/3388",
#       :body => read_fixture("register_intent.json"),
#       :content_type => "application/json",
#       :status => ["200", "Success"]
#     )

#     result = @client.register_intent(3388)
#     assert_equal("http://staging.spectrumsurveys.com:3000/startsurvey?survey_id=3388&supplier_id=49", result)
#   end

#   def test_request_error_raise_when_error
#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/my/path",
#       :body => { "status" => "failure", "msg" => { "error" => "ERROR" } }.to_json,
#       :content_type => "application/json",
#       :status => ["500", "Error"]
#     )

#     exception =
#       assert_raises(PureSpectrumClient::RequestError) do
#         @client.make_request("/my/path")
#       end

#     assert exception.message.is_a? String
#     assert_equal "{\"error\"=>\"ERROR\"}", exception.message
#     assert_equal "http://staging.spectrumsurveys.com:3000/suppliers/v2/my/path?", exception.api_request_details[:url].to_s
#   end

#   def test_request_exception_raise_when_non_json
#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/my/path",
#       :body => '<html>
#         <head><title>400 Broked</title></head>
#         <body bgcolor="white">
#         <center><h1>400 Broked</h1></center>
#         </body>
#         </html>',
#       :content_type => "application/json",
#       :status => ["400", "Bad Request"]
#     )

#     exception =
#       assert_raises(PureSpectrumClient::RequestError) do
#         @client.make_request("/my/path")
#       end

#     assert exception.message.is_a? String
#     assert_equal "Response body cant be parsed as JSON", exception.message
#     assert_equal "http://staging.spectrumsurveys.com:3000/suppliers/v2/my/path?", exception.api_request_details[:url].to_s
#   end

#   def test_api_outage
#     FakeWeb.register_uri(
#       :get,
#       "http://staging.spectrumsurveys.com:3000/suppliers/v2/my/path",
#       :body => '',
#       :content_type => "application/json",
#       :status => ["502", "Bad Gateway"]
#     )

#     exception =
#       assert_raises(PureSpectrumClient::RequestError) do
#         @client.make_request("/my/path")
#       end

#     assert exception.message.is_a? String
#     assert_equal "Provider API outage", exception.message
#     assert_equal "http://staging.spectrumsurveys.com:3000/suppliers/v2/my/path?", exception.api_request_details[:url].to_s
#   end
# end
