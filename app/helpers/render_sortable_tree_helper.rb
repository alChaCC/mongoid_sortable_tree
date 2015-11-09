module RenderSortableTreeHelper
  module Render 
    class << self
      attr_accessor :helper, :options

      def render_node(helper, options)
        @helper, @options = helper, options
        node = options[:node]
        id_field = options[:id]
        li_attr_field = options[:li_attr]
        "
          <ul>
            <li id='#{ node.send(id_field) }' #{node.send(li_attr_field)} >
              #{ show_link }
              #{ children }
            </li>
          </ul>
        "
      end

      def show_link
        node = options[:node]
        title_field = options[:title]
        a_attr_field = options[:a_attr]
        "<a #{node.send(a_attr_field)}>#{node.send(title_field)}</a>"
      end

      def children
        unless options[:children].blank?
          options[:children]
        end
      end

    end
  end
end