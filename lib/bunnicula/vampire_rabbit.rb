class Bunnicula::VampireRabbit < Bunnicula::Rabbit

  attr_reader :relays

  def initialize
    @relays = []
  end

  def relay(*args,&block)
    options = args.extract_options!
    args = [""] if args.length == 0 && block_given?
    args.each do |from_exchange_name|
      relay = Bunnicula::Relay.new
      relay.from(from_exchange_name,options.dup)
      relay.instance_eval(&block) if block_given?
      @relays << relay
    end
  end

  def bite(amq)
    DaemonKit.logger.info "Setting up relays to #{host}:#{port}, vhost=#{vhost} as #{username}"
    @bunny = Bunnicula::BunnyFarm.breed(:host=>host, :port=>port, :vhost=>vhost, :user=>username, :pass=>password)
    @relays.each do |relay|
      relay.start(amq,@bunny)
    end
    DaemonKit.logger.info "Let the good times roll, #{host}"
  end

end