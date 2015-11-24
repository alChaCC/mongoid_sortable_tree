#MongoidSortableTree

Mongoid_sortable_tree helps you build views for Mongoid-tree using jstree.

This gem is inspired by [the_sortable_tree](https://github.com/the-teacher/the_sortable_tree). 

> This is my first gem, if there are any problems, please do not hesitate to contact me.

## Table of contents

- [Setup](#setup)
- [What's Done](#demo)
- [Usage](#how-to-use)
- [TODO](#todo)
- [Аcknowledgment](#acknowledgment)
- [License](#license)


## Setup

To install, add this line to your `Gemfile` and run `bundle install`:

```ruby
gem 'mongoid_sortable_tree'
```

Please make sure that you have:

```ruby
gem "mongoid-tree"
gem "jstree-rails-4"
```

## Demo

![Drag and Drop GUI](https://dl.dropboxusercontent.com/u/22307926/Blog%20Image/mongoid_sortable_tree/Mongoid_Srotable_Tree_example.png)

## How to Use

### Add these lines to your `app/assets/javascripts/application.js`

```ruby
//= require jquery
//= require jquery_ujs
//= require jstree
//= require mongoid_sortable_tree
``` 

### Add these lines to your `app/assets/stylesheets/application.css`

ref: [jstree-rails-4](https://github.com/kesha-antonov/jstree-rails-4)

```ruby
*= require jstree-default

# or 

*= require jstree-default-dark
```

### In Model 

Assume that you have a model `app/models/tag.rb`

```ruby
class Tag
  include Mongoid::Document
  include MongoidSortableTree::Tree
end
```

after include `MongoidSortableTree::Tree`, you now support these fields and mongoid-tree's methods.

```ruby
include Mongoid::Tree
include Mongoid::Tree::Ordering
include Mongoid::Tree::Traversal
field :text, :type => String
field :icon, :type => String
field :li_attr, :type => String
field :a_attr, :type => String
```

### In Controller

Assume that you will use controller `app/controllers/tags_controller.rb`

```ruby
class TagsController < ApplicationController
  include MongoidSortableTreeController::CRUD
  def index
    @tags = Tag.all
  end
end
```

### In View

Assume that you will show tree GUI in `index.html.slim`

```ruby
#mongoid-sorable-js-tree
  = build_server_tree @tags
```

### In Route

Add these lines to `config/routes.rb`

```ruby
resources :tags do 
  collection do 
    post 'check'
  end
end
```

### Finally, initialize your view for jstree using helper

Assume that you have `app/assets/javascripts/tags.js`

```ruby
$(document).on('ready page:load', function() {
  jstree_helper.init('#mongoid-sorable-js-tree');
});
```

## Todo 

- Support [Json Data](https://www.jstree.com/docs/json) View
- More customization supports 
- Travis CI、codeclimate ...etc


## Acknowledgment

1. [the-teacher/the_sortable_tree](https://github.com/the-teacher/the_sortable_tree)
2. [jsTree](https://www.jstree.com/)
3. [benedikt/mongoid-tree](https://github.com/benedikt/mongoid-tree)

## License

Copyright 2015 Chun-Yu, Chen (Aloha Chen)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
