# Generated amqp daemon

# Do your post daemonization configuration here
# At minimum you need just the first line (without the block), or a lot
# of strange things might start happening...
DaemonKit::Application.running! do |config|
  # Trap signals with blocks or procs
  # config.trap( 'INT' ) do
  #   # do something clever
  # end
  config.trap( 'TERM', Proc.new { Bunnicula::BunnyFarm.stop } )
end

if( config = DaemonKit.arguments.options[:configuration_file])
  load config if File.exist?(config)
end

if (source_uri = DaemonKit.arguments.options[:source_uri])
  Bunnicula.victim(source_uri)
end

if (DaemonKit.arguments.options[:targets])
  targets = DaemonKit.arguments.options[:targets]
  targets.each do |target_config|
    Bunnicula.transfusion_to(target_config[:target_uri]) do |vamp|
      target_config[:relays].each do |relay_config|
        vamp.relay do |r|
          from_options = {}
          from_options[:durable] = relay_config[:from_durable] if relay_config[:from_durable]
          from_options[:ack] = relay_config[:from_ack] if relay_config[:from_ack]
          from_options[:type] = relay_config[:from_type] if relay_config[:from_type]
          r.from relay_config[:from], from_options
          if (to_exchange = relay_config[:to])
            to_options = {}
            to_options[:durable] = relay_config[:to_durable] if relay_config[:to_durable]
            to_options[:ack] = relay_config[:to_ack] if relay_config[:to_ack]
            to_options[:type] = relay_config[:to_type] if relay_config[:to_type]
            r.to to_exchange, to_options
          end
        end
      end
    end
  end
end

# Run an event-loop for processing
raise "Bunnicula requires a victim. Please specify a source rabbitmq instance via a configuration file or commandline argument" unless Bunnicula.victim
Bunnicula::AMQP.run(Bunnicula.victim.to_h) do
  # Inside this block we're running inside the reactor setup by the
  # amqp gem. Any code in the examples (from the gem) would work just
  # fine here.

  # Uncomment this for connection keep-alive
  # AMQP.conn.connection_status do |status|
  #   DaemonKit.logger.debug("AMQP connection status changed: #{status}")
  #   if status == :disconnected
  #     AMQP.conn.reconnect(true)
  #   end
  # end

  amq = ::MQ.new
  Bunnicula.suck(amq)
end
