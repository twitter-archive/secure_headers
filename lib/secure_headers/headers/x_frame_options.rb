module SecureHeaders
  class XFOBuildError < StandardError; end
  class XFrameOptions < Header
    module Constants
      XFO_HEADER_NAME = "X-Frame-Options"
      DEFAULT_VALUE = 'SAMEORIGIN'
      VALID_XFO_HEADER = /\A(SAMEORIGIN\z|DENY\z|ALLOW-FROM[:\s])/i
      CONFIG_KEY = :x_frame_options
    end
    include Constants

    def initialize(config = nil)
      @config = config
      validate_config unless @config.nil?
    end

    def name
      XFO_HEADER_NAME
    end

    def value
      case @config
      when NilClass
        DEFAULT_VALUE
      when String
        @config
      else
        warn "[DEPRECATION] secure_headers 3.0 will only accept string values for XFrameOptions config"
        @config[:value]
      end
    end

    private

    def validate_config
      value = @config.is_a?(Hash) ? @config[:value] : @config
      unless value =~ VALID_XFO_HEADER
        raise XFOBuildError.new("Value must be SAMEORIGIN|DENY|ALLOW-FROM:")
      end
    end
  end
end
