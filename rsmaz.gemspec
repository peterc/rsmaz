# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rsmaz}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Cooper"]
  s.date = %q{2009-04-02}
  s.description = %q{Short String Compression for Ruby.  RSmaz is a pure-Ruby port of the Smaz short string compression algorithm by Salvatore Sanfilippo and released as a C library at: http://github.com/antirez/smaz/tree/master  I've done some initial cleanup of a pure Ruby->C port, but this is not yet complete. It does pass the specs, however! Feel free to clean it up as it's a bit memory inefficient right now... :)}
  s.email = ["pcooper@petercooper.co.uk"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/rsmaz.rb", "script/console", "script/destroy", "script/generate", "spec/rsmaz_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/peterc/rsmaz/tree/master}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rsmaz}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Short String Compression for Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
