# frozen_string_literal: true

module RakeEasyRSA
  module Mixins
    module GitkeepParameters
      def self.included(base)
        super
        base.class_eval do
          parameter :include_gitkeep_files, default: true
        end
      end
    end
  end
end
