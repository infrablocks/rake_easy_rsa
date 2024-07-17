# frozen_string_literal: true

module RakeEasyRSA
  module Mixins
    module AlgorithmParameters
      def self.included(base)
        super
        base.class_eval do
          parameter :algorithm
          parameter :curve
          parameter :ec_directory
        end
      end
    end
  end
end
