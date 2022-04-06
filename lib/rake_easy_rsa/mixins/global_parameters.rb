# frozen_string_literal: true

module RakeEasyRSA
  module Mixins
    module GlobalParameters
      # rubocop:disable Metrics/MethodLength
      def self.included(base)
        super(base)
        base.class_eval do
          parameter :pki_directory, default: './pki'
          parameter :extensions_directory
          parameter :openssl_binary
          parameter :ssl_configuration
          parameter :safe_configuration
          parameter :vars
          parameter :batch, default: true
          parameter :input_password
          parameter :output_password
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
