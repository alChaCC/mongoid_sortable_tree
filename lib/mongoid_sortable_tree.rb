require "mongoid_sortable_tree/engine"

module MongoidSortableTree
  module Tree
    extend ActiveSupport::Concern
    included do
      include Mongoid::Tree
      include Mongoid::Tree::Ordering
      include Mongoid::Tree::Traversal
      field :text, :type => String
      field :icon, :type => String
      field :li_attr, :type => String
      field :a_attr, :type => String
      index :text => 1
    end

    ##
    # This module implements class methods that will be available
    # on the document that includes MongoidSortableTree::Tree
    module ClassMethods
      def build_materialized_path(tailored_hierarchy_data: [], from_root: false, category_hierarchy: nil, klass: nil)
        target = from_root ? (klass.nil? ? self.roots : klass.classify.constantize.roots) : category_hierarchy.children
        target.each do |data|
          custom_display_data = {
            :id       => data.id.to_s,
            :text     => data.text,
            :icon     => data.icon,
            :li_attr  => data.li_attr,
            :a_attr   => data.a_attr,
            :klass    => klass,
            :children => build_materialized_path(category_hierarchy: data, klass: klass)
          }
          tailored_hierarchy_data << custom_display_data
        end
        tailored_hierarchy_data
      end

      def build_tree_from_root(options={})
         build_materialized_path(from_root: true, klass: options[:klass])
      end

      def build_tree_from_node(node,options={})
        return_array = []
        custom_display_data = {
          :id       => node.id.to_s,
          :text     => node.text,
          :icon     => node.icon,
          :li_attr  => node.li_attr,
          :a_attr   => node.a_attr,
          :klass    => options[:klass],
          :children => build_materialized_path(category_hierarchy: node, klass: options[:klass])
        }
        return_array << custom_display_data
      end
    end
  end
end
