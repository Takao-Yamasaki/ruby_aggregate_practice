require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    result = []
    users_data = []

    @channel_names.each do |channel_name|
      data = self.load(channel_name)
      data["messages"].each do |m|
        m["reactions"].nil? ? next : (users_data << m["reactions"].map {|r| r["users"] })
      end
    end
    # users_dataを平坦化
    users_data.flatten!
    # uniqで重複した要素を除く
    users_data.uniq.each do |u|
      hash = {}
      hash[:user_id] = u
      hash[:reaction_count] = users_data.count(u)
      result << hash
    end
    result
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end