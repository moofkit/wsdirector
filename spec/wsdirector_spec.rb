require "spec_helper"

RSpec.describe Wsdirector do
  it "has a version number" do
    expect(Wsdirector::VERSION).not_to be nil
  end

  context "echo server" do
    let(:server) { EchoServer }
    let(:client) { Wsdirector::Client.new(server.url) }
    $message_container = []

    it "does something useful" do
      client1 = nil
      puts "from test #{$message_container.inspect}"
      EM.run do
        server.start
        client1 = client

        EM.add_timer 1 do
          client1.send_message "test"
        end

        # close server
        EM.add_timer 2 do
          client1.close
          EM.stop_event_loop
        end
      end

      expect(client1.message_container).to eq(["test"])
    end
  end
end
