require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'
require 'yaml'
namespace :rdoc do |ns|
  Rake::RDocTask.new(:doc) do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_dir = 'doc'
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
    rd.options << "-t Agree2"
  end

  desc 'Publish RDoc to RubyForge.'
  task :publish_docs => [:doc] do
    config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
    host = "#{config["username"]}@rubyforge.org"

    remote_dir = "/var/www/gforge-projects/agree2"
    local_dir = 'doc'

    sh %{rsync -av --delete #{local_dir}/ #{host}:#{remote_dir}}
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

namespace :gem do |gem|
  File.open( 'agree2.gemspec') do |f|
    @gem=eval(f.read)
    @version=@gem.version.to_s
  end
  
  Rake::GemPackageTask.new @gem do |pkg|
    pkg.need_tar = true
    pkg.need_zip = true
  end

  desc 'Install the package as a gem.'
  task :install => [:clean, :package] do
    gem = Dir['pkg/*.gem'].first
    sh "sudo gem install --local #{gem}"
  end

  
  desc 'Package and upload the release to rubyforge.'
  task :release => [:clean, :package] do |t|
    pkg = "pkg/#{name}-#{@version}"

    if $DEBUG then
      puts "release_id = rf.add_release #{rubyforge_name.inspect}, #{name.inspect}, #{@version.inspect}, \"#{pkg}.tgz\""
      puts "rf.add_file #{rubyforge_name.inspect}, #{name.inspect}, release_id, \"#{pkg}.gem\""
    end

    rf = RubyForge.new.configure
    puts "Logging in"
    rf.login

#    c = rf.userconfig
#    c["release_notes"] = description if description
#    c["release_changes"] = changes if changes
#    c["preformatted"] = true

    files = ["#{pkg}.tgz",
             "#{pkg}.zip",
             "#{pkg}.gem"].compact

    puts "Releasing #{name} v. #{@version}"
    rf.add_release rubyforge_name, name, @version, *files
  end
  
end

desc "Clean up all dirt"
task :clean => [ "rdoc:clobber_doc", "gem:clobber_package" ] do
   %w(diff diff.txt email.txt ri *.gem *~ **/*~ *.rbc **/*.rbc coverage).each do |pattern|
    files = Dir[pattern]
    rm_rf files, :verbose => true unless files.empty?
  end
end

task :default=>[:spec]
