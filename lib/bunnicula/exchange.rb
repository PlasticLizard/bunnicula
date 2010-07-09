class Bunnicula::Exchange

attr_reader :name, :type, :durable, :ack, :routing_key

  def initialize(exchange_name=nil,options={})
    @name = exchange_name
    @type = options.delete(:type) || options.delete(:exchange_type)
    @durable = options.delete(:durable)
    @ack = options.delete(:ack)
    @routing_key = options.delete(:routing_key)
  end

end