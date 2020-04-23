module RakeEasyRSA
  module Tasks
    module Mixins
      module AlgorithmParameters
        def self.included(base)
          super(base)
          base.class_eval do
            parameter :algorithm
            parameter :curve
            parameter :ec_directory
          end
        end
      end
    end
  end
end
