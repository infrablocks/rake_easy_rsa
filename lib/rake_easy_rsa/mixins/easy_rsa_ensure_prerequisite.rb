# frozen_string_literal: true

require 'rake_factory'

module RakeEasyRSA
  module Mixins
    module EasyRSAEnsurePrerequisite
      def self.included(base)
        super
        base.class_eval do
          parameter :ensure_task_name, default: :'easy_rsa:ensure'
          default_prerequisites(RakeFactory::DynamicValue.new do |t|
            [t.ensure_task_name]
          end)
        end
      end
    end
  end
end
