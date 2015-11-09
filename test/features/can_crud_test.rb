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
end
