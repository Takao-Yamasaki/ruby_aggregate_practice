class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    messages_data = @channel_names.map {|channel_name| self.load(channel_name)["messages"]}.flatten
    reaction_count_data = messages_data.map { |m| m["reactions"].nil? ? next : { text: m["text"], reaction_count: m["reactions"].map{|r| r["count"]}.sum } }.compact!
    reaction_count_data.max {|a, b| a[:reaction_count] <=> b[:reaction_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end