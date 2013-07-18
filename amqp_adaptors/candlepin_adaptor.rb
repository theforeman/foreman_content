require 'bunny'
require 'json'
require File.dirname(File.absolute_path(__FILE__)) + '/candlepin_commands/candlepin_commands'

connection = Bunny.new
connection.start
channel = connection.create_channel
queue = channel.queue("foreman.candlepin", :durable => true)

queue.subscribe(:ack => false, :manual_ack => true, :block => true) do |delivery_info, metadata, payload|
  begin
    j = JSON.parse(payload)

    case j["entity"].downcase
      when "product"
        if j["operation"] == "create"
          CandlepinCommands::Products.new.create(j['value'])
          channel.acknowledge(delivery_info.delivery_tag, false)
        else
          puts "entity: #{j[:root]}, operation: #{j["operation"]}, data: #{j}"
        end
      when "repository"
        if j["operation"] == "create"
          CandlepinCommands::Content.new.create(j['value'])
          channel.acknowledge(delivery_info.delivery_tag, false)
        else
          puts "entity: #{j[:root]}, operation: #{j["operation"]}, data: #{j}"
        end
      else
        puts "entity: #{j[:root]}, operation: #{j["operation"]}, data: #{j}"
    end
  rescue Exception => e
    puts "rejecting #{delivery_info.delivery_tag}:#{payload} due to #{e}:#{e.backtrace}"
    channel.reject(delivery_info.delivery_tag, false) # do not requeue
  end
end

channel.work_pool.join
