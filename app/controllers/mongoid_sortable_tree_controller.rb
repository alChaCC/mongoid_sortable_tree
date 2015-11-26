module MongoidSortableTreeController
  # include MongoidSortableTreeController::CRUD
  
  module DefineVariablesMethod
    public
    def the_define_common_variables
      collection = self.class.to_s.split(':').last.sub(/Controller/,'').underscore.downcase                 # 'recipes'
      collection = self.respond_to?(:sortable_collection) ? self.sortable_collection : collection           # 'recipes'
      variable   = collection.singularize                                                                   # 'recipe'
      klass      = self.respond_to?(:sortable_model) ? self.sortable_model : variable.classify.constantize  #  Recipe
      ["@#{variable}", collection, klass]
    end
  end
  
  module CRUD
    include DefineVariablesMethod
    def check
      operation   = params[:operation]
      node        = params[:node]
      node_parent = params[:node_parent] 
      info        = params[:info]
      return render(nothing: true, status: 406) unless operation && node && node_parent
      
      variable, collection, klass = self.the_define_common_variables
      # variable  = self.instance_variable_set(variable, klass.find(id))
      
      validation = self.send(operation.to_sym, node, node_parent, info)

      return render json: {id: validation[:id], operation: operation, message: validation[:msg] }, status: validation[:status]
    end
    def create_node(node,node_parent,info)
      variable, collection, klass = self.the_define_common_variables
      variable  = self.instance_variable_set(variable, klass.new(text: node[:text]))
      variable.parent = klass.where(:id => node_parent[:id]).first
      if variable.valid?
        variable.save
        return {id: variable.id.to_s, msg: 'created', status: 200}
      else
        return {id: variable.id.to_s, msg: variable.errors.full_messages, status: 406}
      end
    end

    def rename_node(node,node_parent,info)
      variable, collection, klass = self.the_define_common_variables
      variable  = self.instance_variable_set(variable, klass.where(:id => node[:id]).first)
      if variable && variable.update_attributes(:text => info)
        return {id: variable.id.to_s, msg: 'updated', status: 200}
      else
        return {id: variable.try(:id).to_s, msg: variable.try(:errors).try(:full_messages), status: 406}
      end
    end

    def delete_node(node,node_parent,info)
      variable, collection, klass = self.the_define_common_variables
      variable  = self.instance_variable_set(variable, klass.where(:id => node[:id]).first)
      if variable && variable.destroy
        return {id: variable.id.to_s, msg: 'deleted', status: 200}
      else
        return {id: variable.id.to_s, msg: variable.errors.full_messages, status: 406}
      end
    end

    def move_node(node,node_parent,info)
      variable, collection, klass = self.the_define_common_variables
      variable  = self.instance_variable_set(variable, klass.where(:id => node[:id]).first)
      parent = klass.where(:id => node_parent[:id]).first
      if variable && variable.update_attribute(:parent_id,parent.try(:id))
        variable.rearrange_children!
        variable.save
        return {id: variable.id.to_s, msg: 'moved', status: 200}
      else
        return {id: variable.id.to_s, msg: variable.errors.full_messages, status: 406}
      end
    end

    def copy_node(node,node_parent,info)
      begin
        variable, collection, klass = self.the_define_common_variables
        variable  = self.instance_variable_set(variable, klass.where(:id => node[:id]).first)
        parent = klass.where(:id => node_parent[:id]).first
        id_mapping = {}
        variable.traverse(:breadth_first).each_with_index do |node,index|
          copied_item = node.clone
          id_mapping[node.id] = copied_item.id
          if index == 0
            copied_item.update_attribute(:parent_id,parent.try(:id))
          elsif id_mapping[copied_item.parent_id]
            copied_item.update_attribute(:parent_id,id_mapping[copied_item.parent_id])
          end
          copied_item.rearrange_children!
          copied_item.save
        end
        return {id: id_mapping.keys.map(&:to_s), msg: 'cpoied', status: 200}
      rescue => e 
        return {id: variable.id.to_s, msg: 'Failed to copy', status: 406}
      end
    end

  end

end