module Bunnicula
  class Rabbit
    extend Bunnicula::DslBase
    #DSL
    dsl_attr :host, :default=>"localhost"
    dsl_attr :username, :password, :default=>"guest"
    dsl_attr :vhost, :default=>"/"
    dsl_attr :port, :default=>5672
  end
end
