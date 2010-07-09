class Bunnicula::Relay
  extend Bunnicula::DslBase

  dsl_attr :filter, :alias=>:where
  attr_reader :source_exchange, :target_exchange

  def from(*args)
    return @source_exchange if args.length == 0
    options = args.extract_options!
    exchange_name = args.pop
    @source_exchange = Bunnicula::Exchange.new(exchange_name,options)
  end

  def to(*args)
    return @target_exchange || @source_exchange if args.length == 0
    options = args.extract_options!
    exchange_name = args.pop
    @target_exchange = Bunnicula::Exchange.new(exchange_name,options)
  end

  #Operational
  def queue_name
    "bunnicula.#{from.name}"
  end

  def start(amq,bunny)
    DaemonKit.logger.info "Starting relay from:#{from.name} to:#{to.name || from.name}"
    @channel = amq
    @bunny = bunny

    prepare_destination_exchange
    bind_to_source_exchange
    subscribe_to_queue

    DaemonKit.logger.info "Relay started"

  end

  private

  def prepare_destination_exchange
    exchange_options = {:type=>to.type || from.type || :direct,
                               :durable=>to.durable || from.durable || true}
    @destination = @bunny.exchange(to.name || from.name, exchange_options)
  end

  def bind_to_source_exchange
    DaemonKit.logger.info "Binding queue #{queue_name} to the source exchange #{from.name}"
    @queue = @channel.queue(queue_name,:durable=>from.durable.to_b)
    @exchange = @channel.instance_eval("#{from.type || :direct}('#{from.name}', :durable=>#{from.durable.to_b})")
    binding_options = from.type == :topic ? {:key=>from.routing_key || "#"} : {}
    @queue.bind(@exchange,binding_options)
  end

  def subscribe_to_queue
    @queue.subscribe(:ack=>from.ack) do |header,message|
      routing_key = header.properties[:routing_key]
      DaemonKit.logger.debug "Received message on #{from.name}. Routing Key:#{routing_key}"
      if relay?(header,message)
        DaemonKit.logger.debug "Trasmitting #{routing_key} to #{to.name || from.name}"
        persistent = to.durable || from.durable || true
        begin
          @destination.publish(message, :key=>routing_key, :persistent=>persistent)
          header.ack
          DaemonKit.logger.debug "#{routing_key} transmitted and acknowledged"
        rescue RuntimeError=>ex
          Debug.error "#{routing_key} could not be delivered due to an error"
          DaemonKit.logger.exception  ex
        end
      else
        DaemonKit.logger.debug "#{routing_key} did not satisfy the configured filter (#{filter.inspect})"
      end
    end
  end

  def relay?(header,message)
    return true unless filter
    return header.properties[:routing_key] =~ filter if filter.is_a?(Regexp)
    if (filter.is_a?(Proc))
      return filter.call if proc.arity  <= 0
      return filter.call(header) if proc.arity == 1
      return filter.call(header,message)
    end
    #default behavior
    header.properties[:routing_key] == filter.to_s
  end
end