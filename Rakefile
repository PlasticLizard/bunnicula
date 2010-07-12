require File.dirname(__FILE__) + '/config/boot'

require 'rake'
require 'daemon_kit/tasks'
require 'rake/testtask'

Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |rake| load rake }

Rake::TestTask.new do |t|
  t.libs << 'libs' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

begin
  require 'jeweler'
  require File.dirname(__FILE__) + "/lib/bunnicula/version"

  Jeweler::Tasks.new do |s|
    s.name = "bunnicula"
    s.version = Bunnicula::VERSION
    s.summary = "A very simple relay for moving messages from a local broker to a remote broker"
    s.description = "Bunnicula is a simple AMQP relay implemented as a ruby daemon (a-la daemon-kit). Similar in intent to shovel, Bunnicula is intended to enable the common messaging scenario where services and applications publish messages to an AMQP broker on the local LAN for speed and reliability which are then subsequently relayed to a remote AMQP instance by a relay process which isn�t so irritable as message producers tend to be when it comes to network speed and reliability. Bunnicula can be configured via configuration file (a Ruby DSL) or, for most common configurations, through command line arguments."
    s.email = "hereiam@sonic.net"
    s.homepage = "http://github.com/PlasticLizard/bunnicula"
    s.authors = ["Nathan Stults"]
    s.has_rdoc = false #=>Should be true, someday
    s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
    s.files = FileList["[A-Z]*", "{bin,lib,config,vendor,libexec,test}/**/*"]

    s.add_dependency('bunny', '0.6.0')
    s.add_dependency('amqp', '0.6.7')

    s.add_development_dependency('shoulda', '2.11.1')
  end

  Jeweler::GemcutterTasks.new

rescue LoadError => ex
  puts "Jeweler not available. Install it for jeweler-related tasks with: sudo gem install jeweler"

end

task :default => :test