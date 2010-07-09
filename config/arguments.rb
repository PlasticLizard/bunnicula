# Argument handling for your daemon is configured here.
#
# You have access to two variables when this file is
# parsed. The first is +opts+, which is the object yielded from
# +OptionParser.new+, the second is +@options+ which is a standard
# Ruby hash that is later accessible through
# DaemonKit.arguments.options and can be used in your daemon process.

# Here is an example:
# opts.on('-f', '--foo FOO', 'Set foo') do |foo|
#  @options[:foo] = foo
# end


opts.on('-c PATH','--config_path PATH') do |config|
  @options[:configuration_file] = config
end

opts.on('-s SOURCE','--source SOURCE') do |source_uri|
  @options[:source_uri] = source_uri
end

opts.on('-t TARGET','--target TARGET') do |target_uri|
  @options[:targets] ||= []
  @options[:targets] << {:target_uri=>target_uri}
end

opts.on('-r RELAY', '--relay RELAY') do |relay|
  raise "You specified a RELAY parameter, but did not first specify a TARGET parameter. Please indicate the target AMQP server in the form of -t TARGET or --target TARGET" unless @options[:targets]
  @options[:targets][-1][:relays] ||= []
  @options[:targets][-1][:relays] << {:from=>relay}
end

opts.on('-y TO', '--to TO') do |to|
  puts to
  raise "You specified a RELAY_TO parameter, but did not first specify a RELAY parameter. Please indicate the target AMQP server in the form of -r RELAY or --relay RELAY" unless @options[:targets] && @options[:targets][-1][:relays]
  relay = @options[:targets][-1][:relays][-1]
  relay[:to] = to
end

opts.on('-x TYPE', '--type TYPE') do |type|
  raise "You specified a TYPE parameter, but did not first specify a RELAY parameter. Please indicate the target AMQP server in the form of -r RELAY or --relay RELAY" unless @options[:targets] && @options[:targets][-1][:relays]
  relay = @options[:targets][-1][:relays][-1]
  if relay[:to]
    relay[:to_type] = type.downcase.to_sym
  else
    relay[:from_type] = type.downcase.to_sym
  end
end

opts.on('-d','--durable') do |durable|
  raise "You specified a DURABLE parameter, but did not first specify a RELAY parameter. Please indicate the target AMQP server in the form of -r RELAY or --relay RELAY" unless @options[:targets] && @options[:targets][-1][:relays]
  relay = @options[:targets][-1][:relays][-1]
  if relay[:to]
    relay[:to_durable] = durable
  else
    relay[:from_durable] = durable
  end
end

opts.on('-a','--ack') do |ack|
  raise "You specified a ACK parameter, but did not first specify a RELAY parameter. Please indicate the target AMQP server in the form of -r RELAY or --relay RELAY" unless @options[:targets] && @options[:targets][-1][:relays]  
  relay = @options[:targets][-1][:relays][-1]
  if relay[:to]
    relay[:to_ack] = ack
  else
    relay[:from_ack] = ack
  end
end

