require 'bunny'
require 'json'
require File.dirname(File.absolute_path(__FILE__)) + '/pulp_commands/pulp_commands'

connection = Bunny.new
connection.start
channel = connection.create_channel
queue = channel.queue("foreman.pulp", :durable => true)

queue.subscribe(:ack => false, :manual_ack => true, :block => true) do |delivery_info, metadata, payload|
  begin
    j = JSON.parse(payload)

    case j["entity"].downcase
      when "repository"
        if j["operation"] == "create"
          PulpCommands::Repositories.new.create(j['value'])
          channel.acknowledge(delivery_info.delivery_tag, false)
        else
          puts "entity: #{j[:root]}, operation: #{j["operation"]}, data: #{j}"
        end
      else
        puts "entity: #{j[:root]}, operation: #{j["operation"]}, data: #{j}"
    end
  rescue RestClient::ServiceUnavailable => e
    puts "Pulp service unavailable during creating repository. #{delivery_info.delivery_tag}:#{payload}"
    channel.reject(delivery_info.delivery_tag, true) # requeue!
  rescue Exception => e
    puts "rejecting #{delivery_info.delivery_tag}:#{payload} due to #{e}:#{e.backtrace}"
    channel.reject(delivery_info.delivery_tag, false) # do not requeue
  end
end

channel.work_pool.join
