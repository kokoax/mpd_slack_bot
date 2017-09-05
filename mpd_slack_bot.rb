require 'slack-ruby-client'

# 先ほど取得したTOKENをセット
TOKEN = ENV['SLACK_API_TOKEN']

Slack::RealTime.config do |config|
  config.token = TOKEN
  config.start_method = :rtm_start
end

Slack.configure do |conf|
  conf.token = TOKEN
end

# RTM Clientのインスタンス生成
client = Slack::RealTime::Client.new

# slackに接続できたときの処理
client.on :hello do
  puts 'connected!'
end

# ユーザからのメッセージを検知したときの処理
client.on :message do |data|
  if data['text'].match(%r(^:mpc))
    cmd = data['text'][1..-1].split
    cmd = cmd.map{|item| item.gsub(/<|>/, "")}
    puts cmd.join(" ")
    client.message channel: data['channel'], text: "Hi!"
  end
end

client.on :close do |_data|
  p _data
  puts "Client is about to disconnect"
end

client.on :closed do |_data|
  p _data
  puts "Client has disconnected successfully!"
end

client.start!

