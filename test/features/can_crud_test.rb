require "test_helper"

class CanCrudTest < Capybara::Rails::TestCase
  before do 
    @root   = create(:tag, text: 'root', icon: 'root_icon', li_attr: 'root_li', a_attr: 'root_a')
    @child_1  = create(:tag, text: 'root_child1', li_attr: "class='hello'")
    @child_2  = create(:tag, text: 'root_child2', a_attr: "id='hello'")
    @children_1  = create(:tag, text: 'root_child1_children1')
    @root.children << @child_1
    @root.children << @child_2
    @child_1.children << @children_1
    visit tags_path
  end
  it "will have jstree effect", js: true do 
    find_by_id("#{@root.id.to_s}").right_click
    page.must_have_content('Create')
    page.must_have_content('Edit')
    page.must_have_content('Rename')
  end

  it "can create a root node by javascript", js: true do 
    assert_difference 'Tag.count' do
      find_by_id("add-root-node").click
      sleep 2
    end
    page.must_have_content("test_add_root")
  end

  it "can create a node under parent", js: true do
    find_by_id("#{@root.id.to_s}").right_click
    assert_difference 'Tag.count' do
      find_link('Create').click
      sleep 2
    end
    page.must_have_xpath("//input[@value='New node']")
  end

  it "can rename a node", js: true do
    find_by_id("#{@root.id.to_s}").right_click
    find_link('Rename').click
    find(:xpath, "//input[@value='root']").set('root_hello')
    find(:xpath, "//input[@value='root']").native.send_keys(:return)
    page.must_have_content('root_hello')
    sleep 2
    assert_equal 'root_hello', @root.reload.text
  end

  it "can delete a node", js: true do
    find_by_id("#{@root.id.to_s}").find('a').double_click
    find_by_id("#{@child_1.id.to_s}").right_click
    assert_difference 'Tag.count', -1 do
      find_link('Delete').click
      sleep 2
    end
    page.wont_have_content('root_child1')
  end  

  it "can move a node from A to B", js: true do 
    find_by_id("#{@root.id.to_s}").find('a').double_click
    find_by_id("#{@child_1.id.to_s}").find('a').double_click
    draggable = find_by_id("#{@children_1.id.to_s}").find('a')
    droppable = find_by_id("#{@child_2.id.to_s}").find('a')
    draggable.drag_to(droppable)
    sleep 2
    assert_equal @child_2,@children_1.reload.parent
  end

  it "can copy a node from A to B", js: true do 
    find_by_id("#{@root.id.to_s}").find('a').double_click
    find_by_id("#{@child_1.id.to_s}").find('a').double_click
    find_by_id("#{@children_1.id.to_s}").right_click
    find_link('Edit').click
    find_link('Copy').click
    find_by_id("#{@child_2.id.to_s}").right_click
    find_link('Edit').click
    assert_difference 'Tag.count' do
      find_link('Paste').click
      sleep 2
    end
  end

end
