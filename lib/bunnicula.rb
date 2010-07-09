require "rubygems"
require "bunny"

dir = File.dirname(__FILE__)
["support",
 "amqp",
 "bunny_farm",
 "dsl_base",
 "exchange",
 "relay",
 "rabbit",
 "vampire_rabbit",].each {|lib|require File.join(dir,'bunnicula',lib)}


module Bunnicula
  class << self


    def suck(amq)
      vampire_rabbits.each {|vampire|vampire.suck(amq)}
    end

    def vampire_rabbits
      @@vampire_rabbits ||= []
    end

    def bite(&block)
      instance_eval(&block)
    end
    alias configure bite

    def victim(host=nil,&block)
      return (@@victim ||= nil) unless host || block_given?
      @@victim = Bunnicula::Rabbit.new(host)
      if block_given?
        if block.arity > 0
          block.call(@@victim)
        else
          @@victim.instance_eval(&block)
        end
      end
    end
    alias source victim

    def transfusion_to(host=nil,&block)
      rabbit = Bunnicula::VampireRabbit.new(host)
      if block_given?
        if (block.arity > 0)
          block.call(rabbit)
        else
          rabbit.instance_eval(&block)
        end
      end
      vampire_rabbits << rabbit
      rabbit
    end
    alias target transfusion_to

  end

end