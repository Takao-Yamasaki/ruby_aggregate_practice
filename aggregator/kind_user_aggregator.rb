require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    messages_data = @channel_names.map { |channel_name| self.load(channel_name)["messages"] }.flatten
    users_data = messages_data.map { |m| m["reactions"] }.compact.flatten.map { |r| r["users"] }.flatten
    reactions_data = users_data.uniq.map { |u| { user_id: u, reaction_count: users_data.count(u) } }
    reactions_data.max(3){ |a, b| a[:reaction_count] <=> b[:reaction_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end