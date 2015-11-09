module MongoidSortableTreeHelper
  # Default renderers
  TREE_RENDERERS = {
    :sortable => RenderSortableTreeHelper
  }


  ###############################################
  # Common Base Methods
  ###############################################
  def define_class_of_elements_of node
    case
      when node.is_a?(Array) then node.first.class.to_s.underscore.downcase
      when node.nil?       then 'tag'
      else node.class.to_s.underscore.downcase
    end
  end

  def build_tree_html tree, render_module, options = {}
    render_module::Render::render_node(tree, options)
  end

  def build_server_tree(tree, options: {})
    result = ''
    tree   = Array.wrap tree
    opts   = {
      # base options
      :type  => :sortable,    # tree type
      :id    => :id,          # id field
      :node  => nil,          # node
      :title => :text,        # title field
      :li_attr => :li_attr,
      :a_attr => :a_attr,
      :root  => false,    # is it root node?
      :level => 0,        # recursion level
      :boost => {} 
    }.merge!(options)

     # Basic vars
    root = opts[:root]
    node = opts[:node]

    # namespace prepare [Rails require]
    opts[:namespace] = Array.wrap opts[:namespace]

    # Module with **Render** class
    opts[:render_module] = TREE_RENDERERS[opts[:type]] unless opts[:render_module]
    
    opts[:klass] = define_class_of_elements_of(tree) unless opts[:klass]

    if opts[:boost].empty?
      tree.each do |item|
        num = item.parent_id || 0
        opts[:boost][num.to_s] = [] unless opts[:boost][num.to_s]
        opts[:boost][num.to_s].push item
      end
    end

    unless node
      # RENDER ROOTS
      roots = opts[:boost]['0']

      # define roots, if it's need
      if roots.nil? && !tree.empty?
        min_parent_ids = tree.map(&:parent_ids).min { |x,y| x.size <=> y.size }
        roots = tree.select{ |elem| elem.parent_ids == min_parent_ids }
      end

      # children rendering
      if roots
        roots.each do |root|
          _opts  =  opts.merge({ :node => root, :root => true, :level => opts[:level].next, :boost => opts[:boost] })
          result << build_server_tree(tree, options: _opts)
        end
      end
    else
      # RENDER NODE'S CHILDREN
      children_res = ''
      # has parent_id which mean it has children
      children = opts[:boost][node.id.to_s]

      opts.merge!({ :has_children => children.blank? })

      unless children.nil?
        children.each do |elem|
          _opts        =  opts.merge({ :node => elem, :root => false, :level => opts[:level].next, :boost => opts[:boost] })
          children_res << build_server_tree(tree, options: _opts)
        end
      end

      result << build_tree_html(self, opts[:render_module], opts.merge({ :root => root, :node => node, :children => children_res }))
    end
    raw result
  end

end