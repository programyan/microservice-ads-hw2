require_relative 'api'

module AuthService
  class Client
    extend Dry::Initializer[undefined: false]

    include Api

    option :queue, default: proc { create_queue }
    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def self.fetch
      Thread.current['ads_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe do |delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id

          result = JSON(payload, symbolize_names: true)

          @user_id = result.dig(:meta, :user_id)
          @errors = result unless @user_id

          @lock.synchronize { @condition.signal }
        end
      end

      self
    end

    attr_reader :user_id, :errors

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('amq.rabbitmq.reply-to')
    end

    def publish(payload, opts = {})
      @user_id = nil
      @errors = nil
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(app_id: 'ads', correlation_id: @correlation_id, reply_to: @reply_queue.name)
        )

        @condition.wait(@lock)
      end
    end
  end
end