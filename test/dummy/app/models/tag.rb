class Tag
  include Mongoid::Document
  include MongoidSortableTree::Tree
end
