Gem::Specification.new do |s|
  s.name = "agree2"
  s.version = "0.1.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pelle Braendgaard","Lau Taarnskov"]
  s.date = %q{2008-08-23}
  s.description = "Agree2 Ruby client library"
  s.email = ["support@agree2.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "README.rdoc"]
  s.files = %w(History.txt License.txt README.rdoc Rakefile lib/agree2.rb lib/agree2/base.rb lib/agree2/client.rb lib/agree2/user.rb lib/agree2/agreement.rb lib/agree2/agreement.rb lib/agree2/party.rb lib/agree2/proxy_collection.rb lib/agree2/template.rb)
  s.test_files = %w(spec/spec_helper.rb spec/agreement_spec.rb spec/client_spec.rb spec/party_spec.rb spec/proxy_collection_spec.rb spec/template_spec.rb spec/user_spec.rb spec/fixtures/agreement.json spec/fixtures/party.json)
  s.has_rdoc = true
  s.homepage = %q{http://agree2.rubyforge.org}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{agree2}
  s.rubygems_version = %q{1.2.0}
  s.summary = "Agree2 Ruby client library"

  s.add_dependency("ruby-hmac", [">= 0.3.1"])
  s.add_dependency("oauth", [">= 0.2.4"])
  s.add_dependency("json", [">= 1.1.3"])
  s.add_dependency("activesupport", [">= 2.0.2"])
end
