# Undefined method current_user when using custom devise routes.

I was having a strange error with devise recently.  Devise provides the `current_user` method in controllers, views, and helpers.  It finds the current user based on information in the session, and it's really convenient.

While I was adding devise to a new app recently, all of a sudden, I started getting the error above.  `current_user` wasn't working.

I started looking through all of my devise configuration, and the cause of the problem surprised me.

## Metaprogramming and Ruby: A love story

Rubyists love metaprogramming.  As a refresher, metaprogramming occurs when we call a method that results in a lot more code getting loaded into our program.  A very familiar example to Rails developers is `belongs_to`.  When we type `belongs_to :author` in a model, [several new methods get defined on that model](http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#method-i-belongs_to).  Devise, like many of the great Ruby gems, is full of metaprogramming.

    class User < ActiveRecord::Base
      devise  :database_authenticatable, :registerable,
              :recoverable, :rememberable
    end

It's stood to reason that the `current_user` method was defined by one of these metaprogramming methods, and so something in my configuration was resulting in it not being defined.

I looked at the source code, and it turned out that my problem was in my custom routing.  Devise provides a convenience method for your `config/routes.rb` file.

    devise_for :users

I didn't like the defaults and wanted to do custom routing, so I didn't call that in my routes file.  It turns out (!) that the `current_user` method is defined via the `devise_for` method.  Note that `devise_for` calls out to `Devise#add_mapping` ([source code](https://github.com/plataformatec/devise/blob/v3.4.1/lib/devise/rails/routes.rb#L224)):

	def devise_for(*resources)
	  # ... other stuff
	  resources.each do |resource|
        mapping = Devise.add_mapping(resource, options)
        # ... other stuff

The first step to understanding this code is remembering that Devise allows you to have multiple resources that act as authenticatable users.  You could have two different Active Record objects, one called a PublicUser, and one called an AdminUser, that shared no functionality between them, and you could define two different devise configurations between them.  That is why this class loops through each of the resources that Devise has been told about.

However, most of us use the default, which is to have a single class called User as a devise resources.  The next method, `add_mapping`, tells the global Devise configuration about that resource, and that method ends up defining the `current_user` method (or, in the case of multiple resources given above, it would define two methods, `current_public_user` and `current_admin_user`). See [`lib/devise.rb`](https://github.com/plataformatec/devise/blob/v3.4.1/lib/devise.rb#L339) and [`lib/devise/controllers/helpers.rb`](https://github.com/plataformatec/devise/blob/v3.4.1/lib/devise/controllers/helpers.rb#L120).

This is surprising!  Metaprogramming should generally only affect the class it is used in.  The assumption being made in the Devise gem is that either all users will use the Devise helper in their routes file, or that users using custom routes wouldn't need the `current_user` method defined for them.

To get around this without using the `devise_for` method in my routes, I explicitly added the mappings myself.  Devise already creates an initializer for your devise configuration, so I just placed it in `config/initializers/devise.rb`, at the very end of the file.

    Devise.add_mapping(:user, {})

Since an initializer is called before any of the view/controller code, and it gets called on every request, this accomplishes the same as having it get loaded in the routes file.

To sum up: __When having trouble with a missing method that you usually get from a gem, check out the metaprogramming used in the gem.  The functionality you are missing may come from an unexpected method call in that gem.  In `devise`, the `current_user` method is generally defined by calling `devise_for` in the `config/routes.rb` file.__
