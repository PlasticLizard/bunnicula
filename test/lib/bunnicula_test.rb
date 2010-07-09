require "test_helper"

class BunniculaTest < Test::Unit::TestCase
  context "Excuting a representative relay file" do
    setup do
      require "config/Relayfile"
    end

    should "configure the victim" do
      victim = Bunnicula.victim
      assert_equal "a-host", victim.host
      assert_equal 12345, victim.port
      assert_equal "a", victim.username
      assert_equal "b", victim.password
      assert_equal "/tada", victim.vhost 
    end
    should "configure two vampire rabbits" do
      assert_equal 2, Bunnicula.vampire_rabbits.length
    end
    should "use default values for target rabbit connection when no overrides present" do
      vamp = Bunnicula.vampire_rabbits[0]
      assert_equal "example.com", vamp.host
      assert_equal 5672, vamp.port
      assert_equal "guest", vamp.username
      assert_equal "guest", vamp.password
      assert_equal "/", vamp.vhost
    end
    should "accept overrides to default connection values" do
      vamp = Bunnicula.vampire_rabbits[1]
      assert_equal "target_server_1", vamp.host
      assert_equal 12345, vamp.port
      assert_equal "a", vamp.username
      assert_equal "b", vamp.password
      assert_equal "tada", vamp.vhost
    end
    should "configure the correct number of relays per vampire rabbit" do
      assert_equal 1, Bunnicula.vampire_rabbits[0].relays.length
      assert_equal 4, Bunnicula.vampire_rabbits[1].relays.length
    end
    should "construct a default relay with matching from/to exchanges when provided with just a name" do
      relay = Bunnicula.vampire_rabbits[0].relays[0]
      assert_equal "an exchange name", relay.source_exchange.name
      assert_nil relay.source_exchange.type
      assert_nil relay.source_exchange.durable
      assert_nil relay.source_exchange.ack
      assert_nil relay.target_exchange  
    end
    should "construct source and destination relays via a block" do
      relay = Bunnicula.vampire_rabbits[1].relays[0]
      assert_equal "test_source_exchange", relay.from.name
      assert_equal :topic, relay.from.type
      assert_equal true, relay.from.durable
      assert_equal true, relay.from.ack
      assert_equal "test_destination_exchange", relay.to.name
      assert_equal true, relay.to.durable
      assert_nil relay.to.ack
      assert_nil relay.to.type
    end
    should "create a set of relays with common options when created via a list of names" do
      relays = Bunnicula.vampire_rabbits[1].relays[1..3]
      assert_equal "another_exchange",relays[0].from.name
      assert_equal "and_another_exchange",relays[1].from.name
      assert_equal "and_even_another",relays[2].from.name
      relays.each do |relay|
        assert_equal :fanout, relay.from.type
        assert_equal false, relay.from.durable.to_b
        assert_equal true, relay.from.ack
        assert_nil relay.to
      end
    end
  end
end