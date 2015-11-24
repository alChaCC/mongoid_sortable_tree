// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('ready page:load', function() {
  jstree_helper.init('#mongoid-sorable-js-tree');

  $('#add-root-node').on('click', function(){
    jstree_helper.create_node('#',{text: 'test_add_root'})
  })
});