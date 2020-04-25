module RakeEasyRSA
  module Mixins
    module SSLParameters
      def self.included(base)
        super(base)
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
    end
  end
end
