require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    result = []
    
    @channel_names.each do |channel_name|
      message_count = 0

      data = self.load(channel_name)
      data["messages"].map {|m| message_count += 1 if m["type"] == "message" }
      hash = {}
      hash[:channel_name] = channel_name
      hash[:message_count] = message_count
      result << hash
    end

    result.max(3) { |a, b| a[:message_count] <=> b[:message_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end