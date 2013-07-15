require 'bunny'

class Repositories::CandlepinAmqp
  class_attribute :c, :ch, :x, :q

  self.c = ::Bunny.new
  self.c.start
  self.ch = self.c.create_channel
  self.q = self.ch.queue("foreman.candlepin", :durable => true)
  self.x = self.ch.direct("foreman-candlepin")
  self.q.bind(self.x)

  def self.publish(a_msg)
    self.x.publish(a_msg)
  end
end
