module Logging
  module Plugins
    # This is plugin-intialisation module used by `little-plugger` to find the code:
    module Rtail
      extend self

      VERSION = '0.1.2'.freeze unless defined? VERSION

      # Initialiser for `little-plugger`:
      def initialize_rtail
        require File.expand_path('../../appenders/rtail', __FILE__)
      end
    end
  end
end
