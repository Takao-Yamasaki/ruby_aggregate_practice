require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    messages_count_data = @channel_names.map do |channel_name|
      {
        channel_name: channel_name,
        message_count: self.load(channel_name)["messages"].each.count {|m| m["type"] == "message"}
      }
    end

    messages_count_data.max(3) { |a, b| a[:message_count] <=> b[:message_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end