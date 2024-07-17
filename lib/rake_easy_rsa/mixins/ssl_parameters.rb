# frozen_string_literal: true

module RakeEasyRSA
  module Mixins
    module SSLParameters
      # rubocop:disable Metrics/MethodLength
      def self.included(base)
        super
        base.class_eval do
          parameter :expires_in_days
          parameter :digest
          parameter :distinguished_name_mode
          parameter :common_name
          parameter :country
          parameter :province
          parameter :city
          parameter :organisation
          parameter :organisational_unit
          parameter :email
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
