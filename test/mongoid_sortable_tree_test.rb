require 'test_helper'

class MongoidSortableTreeTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, MongoidSortableTree
  end

  describe "build materialized path json" do 
    before do 
      @root   = create(:tag, text: 'root', icon: 'root_icon', li_attr: 'root_li', a_attr: 'root_a')
      @child  = create(:tag, text: 'root_child')
      @root.children << @child
    end

    describe "from root" do 
      it "normal case" do 
        assert_equal([
            {
              :id=> @root.id.to_s, 
              :text=>"root", 
              :icon=>'root_icon', 
              :li_attr=>'root_li', 
              :a_attr=>'root_a', 
              :klass=>nil, 
              :children=>[
                {
                  :id=> @child.id.to_s, 
                  :text=>"root_child", 
                  :icon=>nil, 
                  :li_attr=>nil, 
                  :a_attr=>nil, 
                  :klass=>nil, 
                  :children=>[]
                }
              ]
            }], Tag.build_tree_from_root)
      end
      it "with params[:klass]" do 
        assert_equal([
            {
              :id=> @root.id.to_s, 
              :text=>"root", 
              :icon=>'root_icon', 
              :li_attr=>'root_li', 
              :a_attr=>'root_a', 
              :klass=>'Tag', 
              :children=>[
                {
                  :id=> @child.id.to_s, 
                  :text=>"root_child", 
                  :icon=>nil, 
                  :li_attr=>nil, 
                  :a_attr=>nil, 
                  :klass=>'Tag', 
                  :children=>[]
                }
              ]
            }] , Tag.build_tree_from_root(klass: 'Tag'))
      end
    end

    describe "from a node" do 
      it "normal case" do 
        @children_1  = create(:tag, text: 'root_child_children1')
        @children_2  = create(:tag, text: 'root_child_children2')
        @child.children << @children_1
        @child.children << @children_2
        assert_equal([
              {
                :id=> @child.id.to_s, 
                :text=>"root_child", 
                :icon=>nil, 
                :li_attr=>nil, 
                :a_attr=>nil, 
                :klass=>nil, 
                :children=>[
                  {
                    :id=> @children_1.id.to_s, 
                    :text=>"root_child_children1", 
                    :icon=>nil, 
                    :li_attr=>nil, 
                    :a_attr=>nil, 
                    :klass=>nil, 
                    :children=>[]
                  },
                  {
                    :id=> @children_2.id.to_s, 
                    :text=>"root_child_children2", 
                    :icon=>nil, 
                    :li_attr=>nil, 
                    :a_attr=>nil, 
                    :klass=> nil, 
                    :children=>[]
                  }
                ]
              }], Tag.build_tree_from_node(@child))
      end
      it "with params[:klass]" do
        @children_1  = create(:tag, text: 'root_child_children1')
        @children_2  = create(:tag, text: 'root_child_children2')
        @child.children << @children_1
        @child.children << @children_2
        assert_equal([
              {
                :id=> @child.id.to_s, 
                :text=>"root_child", 
                :icon=>nil, 
                :li_attr=>nil, 
                :a_attr=>nil, 
                :klass=>'Tag', 
                :children=>[
                  {
                    :id=> @children_1.id.to_s, 
                    :text=>"root_child_children1", 
                    :icon=>nil, 
                    :li_attr=>nil, 
                    :a_attr=>nil, 
                    :klass=>'Tag', 
                    :children=>[]
                  },
                  {
                    :id=> @children_2.id.to_s, 
                    :text=>"root_child_children2", 
                    :icon=>nil, 
                    :li_attr=>nil, 
                    :a_attr=>nil, 
                    :klass=>'Tag', 
                    :children=>[]
                  }
                ]
              }], Tag.build_tree_from_node(@child,klass: 'Tag')) 
      end
    end
  end

end
