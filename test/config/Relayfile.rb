Bunnicula.bite {
  victim "amqp://a:b@a-host:12345/tada"

  transfusion_to "example.com" do
    relay "an exchange name"
  end
  
  transfusion_to {
    host     "target_server_1"
    port     12345
    username "a"
    password "b"
    vhost    "tada"

    relay do
      from "test_source_exchange",      :type=>:topic, :durable=>true, :ack=>true
      to   "test_destination_exchange", :durable=>true
    end

    relay  "another_exchange",
           "and_another_exchange",
           "and_even_another",
           :type=>:fanout,
           :durable=>false,
           :ack=>true
  }
}


