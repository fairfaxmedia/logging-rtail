require 'socket'
require 'json'

module Logging::Appenders

  # Factory for the Rtail appender.
  def self.rtail( *args )
    fail ArgumentError, '::Logging::Appenders::Rtail needs a name as first argument.' if args.empty?
    ::Logging::Appenders::Rtail.new(*args)
  end

  # This class provides an Appender that can write to a Rtail service over UDP.
  class Rtail < ::Logging::Appenders::IO

    # Creates a new Rtail Appender that will use the given host and port
    # as the Rtail server destination.
    #
    # @param name [String] Stream ID to differentiate in the Rtail server
    # @param host [String] Host / IP of the Rtail server's UDP receiver (defaults to "localhost")
    # @param port [Integer] Port of the Rtail server's UDP receiver (defaults to 9999)
    def initialize( name, opts = {} )
      @host = opts.fetch(:host, 'localhost')
      @port = opts.fetch(:port, 9999)

      raise ArgumentError, "Empty host and port is not appropriate"  unless host && !host.empty? && port

      # Because it's UDP, we want it flushed to the server, immediately:
      super(name, connect(@host, @port), opts.merge({ :auto_flushing => true }))
    end

    def host; @host.dup; end
    def port; @port; end

    # Reopen the connection to the underlying logging destination. If the
    # connection is currently closed then it will be opened. If the connection
    # is currently open then it will be closed and immediately opened.
    def reopen
      @mutex.synchronize {
        if defined? @io and @io
          flush
          close rescue nil
        end
        @io = connect(@host, @port)
      }
      super
      self
    end

    private

    def connect(host, port)
      UDPSocket.new.tap {|s|  s.connect(host, port) }
    end

    def canonical_write(str)
      return self if @io.nil?

      str = str.force_encoding(encoding) if encoding and str.encoding != encoding
      @io.syswrite JSON.generate({ :id => name, :timestamp => Time.now, :content => str })

      self

    rescue StandardError => err
      self.level = :off
      ::Logging.log_internal {"appender #{name.inspect} has been disabled"}
      ::Logging.log_internal_error(err)
    end

  end
end
