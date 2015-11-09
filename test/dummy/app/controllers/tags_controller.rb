class TagsController < ApplicationController
  include MongoidSortableTreeController::CRUD
  def index
    @tags = Tag.all
  end
end
