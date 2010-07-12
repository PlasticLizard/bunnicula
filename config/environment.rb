# Be sure to restart your daemon when you modify this file

# Uncomment below to force your daemon into production mode
ENV['DAEMON_ENV'] ||= 'production'

# Boot up
require "rubygems"

begin
  require 'amqp'
  require 'mq'
rescue LoadError
  $stderr.puts "Missing amqp gem. Please run 'gem install amqp'."
  exit 1
end

require File.join(File.dirname(__FILE__), 'boot')

DaemonKit::Arguments.parser_available = true
DaemonKit::Initializer.run do |config|

  # The name of the daemon as reported by process monitoring tools
  config.daemon_name = 'bunnicula'

  # Force the daemon to be killed after X seconds from asking it to
  # config.force_kill_wait = 30

  # Log backraces when a thread/daemon dies (Recommended)
  # config.backtraces = true

  # Configure the safety net (see DaemonKit::Safety)
  # config.safety_net.handler = :mail # (or :hoptoad )
  # config.safety_net.mail.host = 'localhost'
end
