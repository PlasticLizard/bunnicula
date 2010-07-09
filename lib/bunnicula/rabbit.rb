require 'uri'

module Bunnicula
  class Rabbit
    extend Bunnicula::DslBase
    #DSL
    dsl_attr :host, :default=>"localhost"
    dsl_attr :username, :password, :default=>"guest"
    dsl_attr :vhost, :default=>"/"
    dsl_attr :port, :default=>5672


    def initialize(constr=nil)
      return unless constr
      if (constr =~ /amqp:\/\//)
        uri = URI.parse(constr)
        host uri.host
        port uri.port || 5672
        username uri.user || "guest"
        password uri.password || "guest"
        vhost uri.path.strip.length < 1 ? "/" : uri.path
      else
        host(constr)
      end
    end

    def to_h
      {
              :host=>host,
              :port=>port,
              :username=>username,
              :password=>password,
              :vhost=>vhost
      }
    end
  end
end
