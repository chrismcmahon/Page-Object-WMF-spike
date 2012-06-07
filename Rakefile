require 'rubygems'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ["-r rspec-extra-formatters", "-f JUnitFormatter", '-o results.xml']
end

RSpec::Core::RakeTask.new(:login_spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern = 'spec/login/*_spec.rb'
end

RSpec::Core::RakeTask.new(:new_page_spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern = 'spec/new_page/*_spec.rb'
end

RSpec::Core::RakeTask.new(:proofread_page_spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern = 'spec/proofread_page/*_spec.rb'
end

RSpec::Core::RakeTask.new(:upload_wizard_spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern = 'spec/upload_wizard/*_spec.rb'
end

task :default => :spec
