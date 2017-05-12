require 'eventmachine'
require 'websocket-eventmachine-server'

module EchoServer
  def self.start
    WebSocket::EventMachine::Server.start(host: '0.0.0.0', port: port) do |ws|
      @channel = EM::Channel.new
      ws.onopen do
        sid = @channel.subscribe do |mes|
          ws.send mes # echo to client
        end
        ws.onmessage do |msg|
          @channel.push msg
        end
        ws.onclose do
          @channel.unsubscribe sid
        end
      end
    end
  end

  def self.port
    (ENV['WS_PORT'] || 18_081).to_i
  end

  def self.url
    "ws://localhost:#{port}"
  end
end
