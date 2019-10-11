# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/omniauth_extras/version"

Gem::Specification.new do |s|
  s.version = Decidim::OmniauthExtras.version
  s.authors = ["moustachu"]
  s.email = ["git@moustachu.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-omniauth_extras"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-omniauth_extras"
  s.summary = "A decidim omniauth_extras module"
  s.description = "Decidim Omniauth extras features"

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::OmniauthExtras.version
  s.add_dependency "omniauth", "~> 1.5"
  s.add_dependency "omniauth-oauth2", ">= 1.4.0", "< 2.0"
  s.add_dependency "omniauth_openid_connect", "0.3.1"
  s.add_dependency "omniauth-saml", "~> 1.10"
end
