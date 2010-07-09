require "rubygems"
require "bunny"

dir = File.dirname(__FILE__)
["support",
 "bunny_farm",
 "dsl_base",
 "exchange",
 "relay",
 "vampire_rabbit",].each {|lib|require File.join(dir,'bunnicula',lib)}


module Bunnicula

  def self.initialize
    default_relay = File.join(DAEMON_ROOT,"relay.rb")
    require default_relay if File.exist?(default_relay)

    env_relay_path = File.join(DAEMON_ROOT,"config","relays",DAEMON_ENV+".rb")
    require env_relay_path if File.exist?(env_relay_path)
  end

  def self.bite(amq)
    vampire_rabbits.each {|vampire|vampire.bite(amq)}
  end

  def self.vampire_rabbits
    @@vampire_rabbits ||= []
  end

  def self.transfusion(&block)
    rabbit = Bunnicula::VampireRabbit.new
    rabbit.instance_eval(&block)
    vampire_rabbits << rabbit
    rabbit
  end
end