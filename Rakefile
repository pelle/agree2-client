require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'

namespace :rdoc do |ns|
  Rake::RDocTask.new(:doc) do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  end
end

namespace :spec do |ns|
  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/*.rb']
  end

  desc "Run rcov"
  Spec::Rake::SpecTask.new('rcov') do |t|
    t.spec_files = FileList['spec/*.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude','gems,spec']
  end
end

task :default=>[:spec]
