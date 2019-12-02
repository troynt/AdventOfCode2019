require 'net/http'
require 'uri'
require 'active_support/all'
require 'faye'

def publish_to_browser(channel, obj)
  message = {channel: channel, data: obj }
  uri = URI.parse("http://localhost:9292/faye")
  Net::HTTP.post_form(uri, :message => message.to_json)
end

def publish_with_time(channel, obj)
  publish_to_browser(channel, {
      x: Time.now.to_i * 1000,
      **obj
  })
end