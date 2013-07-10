# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "boxafe"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["AlphaHydrae"]
  s.date = "2013-07-10"
  s.description = "Boxafe encrypts and auto-mounts a folder with encfs and whenever."
  s.email = "hydrae.alpha@gmail.com"
  s.executables = ["boxafe"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "VERSION",
    "bin/boxafe",
    "lib/boxafe.rb",
    "lib/boxafe/box.rb",
    "lib/boxafe/cli.rb",
    "lib/boxafe/config.rb",
    "lib/boxafe/encfs.rb",
    "lib/boxafe/notifier.rb",
    "lib/boxafe/notifier/growl.rb",
    "lib/boxafe/notifier/notification_center.rb",
    "lib/boxafe/program.rb",
    "lib/boxafe/scheduler.rb",
    "lib/boxafe/scheduler/cron.rb",
    "lib/boxafe/scheduler/launchd.rb"
  ]
  s.homepage = "http://github.com/AlphaHydrae/boxafe"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Secure your Dropbox with encfs."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<paint>, ["~> 0.8.5"])
      s.add_runtime_dependency(%q<commander>, ["~> 4.1.2"])
      s.add_runtime_dependency(%q<which_works>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<dotenv>, ["~> 0.8.0"])
      s.add_runtime_dependency(%q<mutaconf>, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<launchdr>, ["= 3"])
      s.add_runtime_dependency(%q<growl>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<terminal-notifier-guard>, ["~> 1.5.3"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, [">= 0"])
      s.add_development_dependency(%q<gem-release>, [">= 0"])
      s.add_development_dependency(%q<rake-version>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<paint>, ["~> 0.8.5"])
      s.add_dependency(%q<commander>, ["~> 4.1.2"])
      s.add_dependency(%q<which_works>, ["~> 1.0.0"])
      s.add_dependency(%q<dotenv>, ["~> 0.8.0"])
      s.add_dependency(%q<mutaconf>, ["~> 0.2.0"])
      s.add_dependency(%q<launchdr>, ["= 3"])
      s.add_dependency(%q<growl>, ["~> 1.0.3"])
      s.add_dependency(%q<terminal-notifier-guard>, ["~> 1.5.3"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
      s.add_dependency(%q<gem-release>, [">= 0"])
      s.add_dependency(%q<rake-version>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<paint>, ["~> 0.8.5"])
    s.add_dependency(%q<commander>, ["~> 4.1.2"])
    s.add_dependency(%q<which_works>, ["~> 1.0.0"])
    s.add_dependency(%q<dotenv>, ["~> 0.8.0"])
    s.add_dependency(%q<mutaconf>, ["~> 0.2.0"])
    s.add_dependency(%q<launchdr>, ["= 3"])
    s.add_dependency(%q<growl>, ["~> 1.0.3"])
    s.add_dependency(%q<terminal-notifier-guard>, ["~> 1.5.3"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
    s.add_dependency(%q<gem-release>, [">= 0"])
    s.add_dependency(%q<rake-version>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

