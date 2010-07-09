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

# Run an event-loop for processing
Bunnicula.initialize
DaemonKit::AMQP.run do
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
  Bunnicula.bite(amq)
end
