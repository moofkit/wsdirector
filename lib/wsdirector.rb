require "wsdirector/version"
require "websocket-client-simple"

class Wsdirector::Client
  attr_accessor :message_container

  def initialize(url)
    @message_container = []
    @client = WebSocket::Client::Simple.connect(url)
    @client.on :open do
      puts "connect!"
    end
    @client.on :message do |msg|
      begin
        puts "recieve message #{msg.data.inspect}"
          message_container << msg.data
        puts "2from client #{message_container.inspect}"
      rescue Exception => ex
        puts ex.inspect
      end
    end
  end

  def send_message(msg)
    @client.send msg
  end

  def close
    @client.close
  end
end
