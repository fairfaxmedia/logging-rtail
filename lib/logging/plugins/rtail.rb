module Logging
  module Plugins
    module Rtail
      extend self

      VERSION = '0.1.0'.freeze unless defined? VERSION

      def initialize_rtail
        require File.expand_path('../../appenders/rtail', __FILE__)
      end
    end
  end
end
