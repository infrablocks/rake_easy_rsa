# frozen_string_literal: true

module RakeEasyRSA
  module Mixins
    module EncryptKeyParameters
      def self.included(base)
        super
        base.class_eval do
          parameter :encrypt_key, default: false
        end
      end
    end
  end
end
