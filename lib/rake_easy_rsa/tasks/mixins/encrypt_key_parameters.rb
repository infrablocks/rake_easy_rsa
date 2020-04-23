module RakeEasyRSA
  module Tasks
    module Mixins
      module EncryptKeyParameters
        def self.included(base)
          super(base)
          base.class_eval do
            parameter :encrypt_key, default: false
          end
        end
      end
    end
  end
end