#Bunnicula.transfusion {
#   relay "my_exchange"
#}

#Bunnicula.transfusion {
#
#  host     "target_server_1"
#
#  relay do
#    from "test_source_exchange",      :type=>:topic, :durable=>true, :ack=>true
#    to   "test_destination_exchange", :durable=>true
#  end
#
#  relay  "another_exchange",
#         "and_another_exchange",
#         "and_even_another",
#         :type=>:fanout,
#         :durable=>false,
#         :ack=>true
#
#}

#Bunnicula.transfusion {
#
#  host     "target_server_2"
#  port     12345
#  username "a"
#  password "b"
#  vhost    "/"
#
#  relay  "another_exchange_2"
#
#}