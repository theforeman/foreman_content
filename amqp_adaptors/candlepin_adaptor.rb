require 'bunny'
require 'json'
require './lib/rest/candlepin'

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
          json = Rest::Candlepin::Product.create({ :id => j["value"]["cp_id"],
            :name => j["value"]["name"],
            :multiplier => j["value"]["multiplier"] || 1,
            :attributes => [{:name=>"arch", :value=>"ALL"}]
          })
          channel.acknowledge(delivery_info.delivery_tag, false)
        else
          puts "entity: #{j[:root]}, operation: #{j["operation"]}, data: #{j}"
        end
      when "repository"
        if j["operation"] == "create"
          Rest::Candlepin::Content.create({ :id => j["value"]["id"],
              :name => j["value"]["name"],
              :contentUrl => j["value"]["relative_path"].slice(/.*?\/.*?\/(.*)/, 1), # TODO: contentUrl is a subpath of the repo path
              :type => "yum",
              :label =>  j["value"]["cp_label"],
              :vendor => "Custom" })
          Rest::Candlepin::Product.add_content(j["value"]["product"]["id"], j["value"]["id"], true)
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
