if( config = DaemonKit.arguments.options[:configuration_file])
  load config if File.exist?(config)
end

if (source_uri = DaemonKit.arguments.options[:source_uri])
  Bunnicula.victim(source_uri)
end

if (DaemonKit.arguments.options[:targets])
  DaemonKit.logger.debug("Target options from commandline:#{DaemonKit.arguments.options[:targets].inspect}")
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