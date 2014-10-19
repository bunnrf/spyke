require 'spike/relation'
require 'spike/result'

module Spike
  module Associations
    class Association < Relation

      attr_reader :parent

      def initialize(name, parent, options = {})
        super (options[:class_name] || name.to_s).classify.constantize
        @name, @parent, @options = name, parent, options
      end

      def self.activate(*args)
        new(*args).activate
      end

      # Override for plural associations that return an association
      def activate
        find_one
      end

      private

        def foreign_key
          (@options[:foreign_key] || "#{parent.class.model_name.param_key}_id").to_sym
        end

        def fetch
          fetch_embedded || super
        end

        def fetch_embedded
          Result.new(data: embedded_result) if embedded_result
        end

        def embedded_result
          parent.attributes[@name]
        end

    end
  end
end
