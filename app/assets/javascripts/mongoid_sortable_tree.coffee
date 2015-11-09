jQuery ->
  jstree_helper = window.jstree_helper
  if !jstree_helper
    jstree_helper = window.jstree_helper =
      default_setting: 
        update_url: '/tags'
        create_url: '/tags'
        show_url: '/tags'
        destroy_url: '/tags'
        index_url: '/tags'
        check_url: '/tags/check'

      mregeSettings: (optsArr) ->
        setting = @default_setting
        optsArr = if typeof optsArr != 'undefined' then [optsArr] else []
        idx = 0
        len = optsArr.length
        curr = undefined
        key = undefined
        while idx < len
          curr = optsArr[idx]
          for key of curr
            k = key
            setting[k] = curr[k]
          idx++
        setting

      create: (parent_id,text) -> 
        $.ajax
          url: @default_setting.create_url
          data: { "text": data, "parent_id": parent_id}
          type: 'POST'

      init: (target,args) ->
        settings = @mregeSettings(args)
        $(target).jstree
          'core':
            'animation': 0
            'check_callback': (operation,node,node_parent,info) -> 
              if this.get_buffer().mode == 'copy_node'
                operation = 'copy_node'
              $.when(
                $.ajax
                  url: settings.check_url
                  data: { "operation": operation, "node": node, "node_parent": node_parent, "info": info}
                  type: 'GET'
                  target: target
                  node: node
                  node_parent: node_parent
              ).then((data, textStatus, jqXHR) -> 
                if textStatus == 'success'
                  if data.operation == 'create_node'
                    new_node_id = $('#'+this.node_parent.id).find("input[value='"+this.node.text+"']").closest('li').attr('id')
                    $.jstree.reference(this.target).set_id(new_node_id,data.id)
                  if data.operation == 'copy_node'
                    location.reload()
                    # new_node_id = $('#'+this.node_parent.id).find("a:contains('"+ this.node.text+"')").closest('li').attr('id')
                    # $.jstree.reference(this.target).set_id(new_node_id,data.id)
                  true
              ).fail ->
                $.jstree.reference(this.target).refresh()
                false
            'themes': 'stripes': true
          'dnd':
            'check_while_dragging': false 
          'plugins': [
            'contextmenu'
            'dnd'
            'search'
            'state'
            'wholerow'
            'changed'
          ]