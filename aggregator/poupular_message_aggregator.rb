class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    result = []

    @channel_names.each do |channel_name|
      data = self.load(channel_name)
      data["messages"].each do |m|
        hash = {}
        hash[:text] =  m["text"]
        m["reactions"].nil? ? next : (hash[:reaction_count] =  m["reactions"].map { |r| r["count"] }.sum)
        result << hash
      end
    end
    result.max {|a, b| a[:reaction_count] <=> b[:reaction_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end