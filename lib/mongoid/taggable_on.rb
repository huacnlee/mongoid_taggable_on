# frozen_string_literal: true

module Mongoid
  module TaggableOn
    extend ActiveSupport::Concern

    included do
      # rdoc
      # find items with tag
      #
      # *Params*
      #
      #   * field_name      tagged field
      #   * tags            match value, allow String or Array, case insensitive, for example: "Ruby,Python" or ["Ruby","Python"] or "ruby"
      #   * match           (any,all,not) match type, default: all
      #
      # *Usage*
      #
      #     Person.tagged_with_on(:skills, "ui design, photograph")
      #     Person.tagged_with_on(:skills, "ui design, photograph").tagged_with_on(:languages, "english,chinese")
      #     Person.tagged_with_on(:skills, "ui design, photograph").paginate(:page => params[:page])
      #
      scope :tagged_with_on, proc { |field_name, tags, opts|
        return [] if field_name.blank?

        opts ||= {}
        opts[:match] ||= ""
        field_name = field_name.to_s.tableize
        tags = split_tag(tags) if tags.is_a?(String)
        tags = tags.collect(&:to_s)
        case opts[:match].to_sym
        when :any then
          any_in("#{field_name}": tags)
        when :not then
          not_in("#{field_name}": tags)
        else
          # ALL
          all_in("#{field_name}": tags)
        end
      }
    end

    module ClassMethods
      # rdoc
      # =Define a tag field
      # *For example:*
      #
      #     class Person
      #       include Mongoid::Document
      #       include Mongoid::TaggableOn
      #       taggable_on :languages
      #       taggable_on :skills
      #     end
      #
      # *Then will has there methods and fields:*
      #
      #     field :languages, :type => Array, :default => []
      #     def language_list; end
      #     def language_list=(value); end
      #     field :skills, :type => Array, :default => []
      #     def skill_list; end
      #     def skill_list=(value); end
      #
      # *Params*
      #
      #   * field_name      <em>name for tag field</em>
      #   * opts[:index]    <em>(true/false) allow create index in MongoDB, default: true</em>
      #
      def taggable_on(field_name, opts = {})
        field_name = field_name.to_s.tableize
        field_name_single = field_name.singularize

        index_code = ""
        if opts[:index] != false
          index_code = "index({#{field_name}: '2d'}, {background: true})"
        end

        class_eval %{
          field :#{field_name}, :type => Array, :default => []

          #{index_code}

          def #{field_name_single}_list=(value)
            if !value.blank?
              self.#{field_name} = self.class.split_tag(value)
            end
          end

          def #{field_name_single}_list
            return "" if self.#{field_name}.blank?
            self.#{field_name}.join(",")
          end

          def #{field_name_single}_list_was
            return "" if self.#{field_name}_was.blank?
            self.#{field_name}_was.join(",")
          end

          def #{field_name_single}_list_changed?
            self.#{field_name}_changed?
          end
        }
      end

      def split_tag(value)
        value.split(%r{,|，|/|\|}).collect(&:strip).uniq
      end
    end
  end
end
