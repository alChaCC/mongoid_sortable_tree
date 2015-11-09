require "test_helper"

class MongoidSortableTreeHelperTest < ActionView::TestCase
  before do 
    @root   = create(:tag, text: 'root', icon: 'root_icon', li_attr: 'root_li', a_attr: 'root_a')
    @child_1  = create(:tag, text: 'root_child1', li_attr: "class='hello'")
    @child_2  = create(:tag, text: 'root_child2', a_attr: "id='hello'")
    @children_1  = create(:tag, text: 'root_child1_children1')
    @root.children << @child_1
    @root.children << @child_2
    @child_1.children << @children_1
  end

  describe "get correct class name" do
    it "with array" do 
      assert_equal 'tag', define_class_of_elements_of(@child_1.ancestors_and_self)
    end
    it "nil" do 
      assert_equal 'tag', define_class_of_elements_of(nil)
    end
    it "other case" do 
      assert_equal 'tag', define_class_of_elements_of(@child_1)
    end
  end

  describe "build html for jstree" do 
    it "build_server_tree from all nodes" do 
      assert_equal("
          <ul>
            <li id='#{@root.id.to_s}' root_li >
              <a root_a>root</a>
              <ul>
                <li id='#{@child_1.id.to_s}' class='hello' >
                  <a >root_child1</a>
                  <ul>
                    <li id='#{@children_1.id.to_s}'  >
                      <a >root_child1_children1</a>
                    </li>
                  </ul>
                </li>
              </ul>
              <ul>
                <li id='#{@child_2.id.to_s}'  >
                  <a id='hello'>root_child2</a>
                </li>
              </ul>
            </li>
          </ul>
        ".gsub(/\s+/, ""), build_server_tree(Tag.all).gsub(/\s+/, ""))
    end
    it "build_server_tree from a nodes" do 
      assert_equal("
          <ul>
            <li id='#{@root.id.to_s}' root_li >
              <a root_a>root</a>
              <ul>
                <li id='#{@child_1.id.to_s}' class='hello' >
                  <a >root_child1</a>
                  <ul>
                    <li id='#{@children_1.id.to_s}'  >
                      <a >root_child1_children1</a>
                    </li>
                  </ul>
                </li>
              </ul>
              <ul>
                <li id='#{@child_2.id.to_s}'  >
                  <a id='hello'>root_child2</a>
                </li>
              </ul>
            </li>
          </ul>
        ".gsub(/\s+/, ""), build_server_tree(@root.descendants_and_self).gsub(/\s+/, ""))
    end
  end

end
