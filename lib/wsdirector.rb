require "wsdirector/version"
require "websocket-client-simple"
require "wsdirector/echoserver"

module Wsdirector
  def self.call
    EM::run{
      Wsdirector::EchoServer.start

      msgs = ['foo','bar','baz']

      EM::add_timer 1 do
        WebSocket::Client::Simple.connect(Wsdirector::EchoServer.url) do |ws|
          ws.on :open do
            puts "connect!"
            msgs.each do |m|
              ws.send m
            end
          end

          ws.on :message do |msg|
            puts msg.data
          end

          EM::add_timer 3 do
            ws.close
            EM::stop_event_loop
          end

          ws.on :close do
            EM::stop_event_loop
          end
        end
      end
    }
  end
end
