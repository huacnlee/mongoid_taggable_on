# coding: utf-8
module Mongoid
  module TaggableOn
    extend ActiveSupport::Concern
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def taggable_on(field_name, opts = {})
        field_name = field_name.to_s.tableize
        field_name_single = field_name.singularize
        
        index_code = ""
        if opts[:index] != false
          index_code = "index :#{field_name}, :background => true"
        end
        
        class_eval %{
          field :#{field_name}, :type => Array, :default => []
          
          #{index_code}
          
          def #{field_name_single}_list=(value)
            if !value.blank?
              self.#{field_name} = value.split(/,|，|\\/|\\|/).collect { |tag| tag.strip }.uniq
            end
          end
          
          def #{field_name_single}_list
            return "" if self.#{field_name}.blank?
            self.#{field_name}.join(",")
          end
        }
      end
    end
  end
end