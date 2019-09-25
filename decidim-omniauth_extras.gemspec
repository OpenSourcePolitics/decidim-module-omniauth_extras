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
end
