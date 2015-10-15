require 'socket'
require 'json'

module Logging
  module Appenders
    # Factory for the Rtail appender.
    def self.rtail(*args)
      fail ArgumentError, '::Logging::Appenders::Rtail needs a name as first argument.' if args.empty?
      ::Logging::Appenders::Rtail.new(*args)
    end

    # This class provides an Appender that can write to a Rtail service over UDP.
    class Rtail < ::Logging::Appenders::IO
      attr_reader :host, :port, :omit_timezone

      # Creates a new Rtail Appender that will use the given host and port
      # as the Rtail server destination.
      #
      # @param name [String] Stream ID to differentiate in the Rtail server
      # @param host [String] Host / IP of the Rtail server's UDP receiver (defaults to "localhost")
      # @param port [Integer] Port of the Rtail server's UDP receiver (defaults to 9999)
      # @param omit_timezone [Boolean] When creating the time-stamp for a log entry, omit the time-zone specifier
      def initialize(name, opts = {})
        @host = opts.fetch(:host, 'localhost')
        @port = opts.fetch(:port, 9999)
        # FIXME: Rtail Server needs to be fixed to allow log-time output in localtime, instead of UTC.
        #        For now, users may need to do this:
        @omit_timezone = opts.fetch(:omit_timezone, false)

        fail ArgumentError, 'Empty host and port is not appropriate' unless host && !host.empty? && port

        # Because it's UDP, we want it flushed to the server, immediately:
        super(name, connect(@host, @port), opts.merge(auto_flushing: true))
      end

      # Reopen the connection to the underlying logging destination. If the
      # connection is currently closed then it will be opened. If the connection
      # is currently open then it will be closed and immediately opened.
      def reopen
        @mutex.synchronize do
          if defined? @io && @io
            flush
            close rescue nil
          end
          @io = connect(@host, @port)
        end

        super
        self
      end

      private

      def connect(host, port)
        UDPSocket.new.tap {|s| s.connect(host, port) }
      end

      def canonical_write(str)
        return self if @io.nil?

        str = str.force_encoding(encoding) if encoding && str.encoding != encoding
        timestamp = omit_timezone ? Time.now.strftime('%FT%T') : Time.now.to_s
        @io.syswrite JSON.generate(id: name, timestamp: timestamp, content: str)

        self

      rescue StandardError => err
        self.level = :off
        ::Logging.log_internal { "appender #{name.inspect} has been disabled" }
        ::Logging.log_internal_error(err)
      end
    end
  end
end
