require 'net/https'
require 'rubygems'
gem 'oauth', ">= 0.2.4"
gem 'json'
gem 'activesupport'
require 'activesupport'
AGREE2_ENV = :production unless defined?(AGREE2_ENV)
AGREE2_URL = (AGREE2_ENV==:development) ? 'http://agree2.dev' : 'https://agree2.com'
module Agree2
  class Agree2Exception < RuntimeError #:nodoc:
  end
end
require 'agree2/client'
require 'agree2/proxy_collection'
require 'agree2/user'
require 'agree2/base'
require 'agree2/agreement'
require 'agree2/party'
require 'agree2/template'



# FireEagle addition to the <code>OAuth::Consumer</code> class. Taken from Yahoo FireEagle GEM
class OAuth::Consumer
  alias_method :create_http_with_verify, :create_http
  # Monkey patch to silence the SSL warnings
  def create_http_without_verify #:nodoc:
    http_object             = create_http_with_verify
    http_object.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme=="https"
    http_object
  end
  alias_method :create_http, :create_http_without_verify
end
