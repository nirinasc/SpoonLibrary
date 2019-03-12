# @author nirina
# Routes Resolver Class For Specific API Version Request
class ApiVersion
  attr_reader :version, :default

  # Class Initializer
  # @param version [String] the api version
  # @param default [Boolean] a flag telling if this version is the default API
  # @example initialize("v2", true)
  def initialize(version, default = false)
    @version = version
    @default = default
  end

  # check whether version is specified or is default
  # @params request [Hash] the api request object
  # @return [Boolean] the match result or the default flag
  def matches?(request)
    check_headers(request.headers) || default
  end

  private

  # check the request headers if there is a version specified from the accept header key
  # @param headers [Hash]
  # @option headers [String] :accept the accept header key
  # @return [Boolean] the match result
  def check_headers(headers)
    # check version from Accept headers; expect custom media type `spoonlibrary`
    accept = headers[:accept]
    accept&.include?("application/vnd.spoonlibrary.#{version}+json")
  end
end
