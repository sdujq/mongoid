# encoding: utf-8
module Mongoid
  module Persistable

    # Defines behaviour for $rename operations.
    #
    # @since 2.0.0
    module Renamable
      extend ActiveSupport::Concern

      # Rename fields from one value to another via $rename.
      #
      # @example Rename the fields.
      #   document.rename(title: "salutation", name: "nombre")
      #
      # @note This does not work for fields in embeds many relations.
      #
      # @param [ Hash ] renames The rename pairs of old name/new name.
      #
      # @return [ true, false ] If the rename suceeded.
      #
      # @since 4.0.0
      def rename(renames)
        prepare_atomic_operation do |coll, selector, ops|
          renames.each do |old_field, new_field|
            old_name = database_field_name(old_field)
            new_name = new_field.to_s
            attributes[new_name] = attributes.delete(old_name)
            ops[atomic_attribute_name(old_name)] = atomic_attribute_name(new_name)
          end
          coll.find(selector).update(positionally(selector, "$rename" => ops))
        end
      end
    end
  end
end
