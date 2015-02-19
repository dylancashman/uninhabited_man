# Unobtrusive ActionController::RoutingError Exceptions
## 2015-02-06

I don't know how many times I've seen an error like "ActionController::RoutingError (No route matches [GET] "/assets/js/docs.min.js")" flash by in my rails server: My bet is thousands of times.  It's one of those errors that doesn't upset the execution of the app, so it's too easy to blame it on development mode, or assume that it's just the mystical asset pipeline complaining.  Today, I figured I'd take a little look at getting rid of it.

## Problem:

In my Rails server, there are several non-critical exceptions that complain about missing javascript or CSS files.

1. __What's causing this - What's asking for these files?__  The execution pipeline of a rails app can be pretty confusing - the application runs through each of the Middleware you're using, then the layout view, then the view itself, as well as any partials.  To add to the confusion, because Ruby is so extensible, any of the included gems can inject themselves at particular points in that execution pipeline.  I think it's one of the downsides to Ruby that makes it very difficult to debug, and I believe it puts the onus on Ruby developers to be excellent at exception handling.

2. __What are the consequences of ignoring this error?__  The error doesn't halt execution, so it probably isn't critical to deal with.  But let's think about what it might mean.

The exception is telling us that a particular asset isn't being loaded.  It might be a JS file that allows your site to function on a particular browser, like an Internet Explorer workaround.  It might be a CSS file that your designer was counting on being in your site.  In my experience, we often fix asset problems when they effect our critical path because we look for and test the critical path, but if we ignore missing assets, we can be excluding users from our site.

3. __How can I fix it?__  When you're working under a deadline, it's always easier to jump write to this - what's the quickest way to fix it?  I think it's best to ask this last, though, so that you completely understand the problem and don't break other things in an effort to resolve the original problem.

Let's get down to it.

----------------------

### Stack Trace and Middleware

A good first step is to take a look at the stack trace.  Unfortunately, the stack trace in Ruby can get pretty complicated, especially if it's a problem with routing or in the load order.

    ActionController::RoutingError (No route matches [GET] "/assets/js/ie10-viewport-bug-workaround.js"):
      actionpack (4.1.4) lib/action_dispatch/middleware/debug_exceptions.rb:21:in `call'
      actionpack (4.1.4) lib/action_dispatch/middleware/show_exceptions.rb:30:in `call'
      railties (4.1.4) lib/rails/rack/logger.rb:38:in `call_app'
      railties (4.1.4) lib/rails/rack/logger.rb:20:in `block in call'
      activesupport (4.1.4) lib/active_support/tagged_logging.rb:68:in `block in tagged'
      activesupport (4.1.4) lib/active_support/tagged_logging.rb:26:in `tagged'
      activesupport (4.1.4) lib/active_support/tagged_logging.rb:68:in `tagged'
      railties (4.1.4) lib/rails/rack/logger.rb:20:in `call'
      actionpack (4.1.4) lib/action_dispatch/middleware/request_id.rb:21:in `call'
      rack (1.5.2) lib/rack/methodoverride.rb:21:in `call'
      rack (1.5.2) lib/rack/runtime.rb:17:in `call'
      activesupport (4.1.4) lib/active_support/cache/strategy/local_cache_middleware.rb:26:in `call'
      rack (1.5.2) lib/rack/lock.rb:17:in `call'
      actionpack (4.1.4) lib/action_dispatch/middleware/static.rb:64:in `call'
      rack (1.5.2) lib/rack/sendfile.rb:112:in `call'
      railties (4.1.4) lib/rails/engine.rb:514:in `call'
      railties (4.1.4) lib/rails/application.rb:144:in `call'
      rack (1.5.2) lib/rack/lock.rb:17:in `call'
      rack (1.5.2) lib/rack/content_length.rb:14:in `call'
      rack (1.5.2) lib/rack/handler/webrick.rb:60:in `service'
      /Users/dylancashman/.rbenv/versions/2.1.2/lib/ruby/2.1.0/webrick/httpserver.rb:138:in `service'
      /Users/dylancashman/.rbenv/versions/2.1.2/lib/ruby/2.1.0/webrick/httpserver.rb:94:in `run'
      /Users/dylancashman/.rbenv/versions/2.1.2/lib/ruby/2.1.0/webrick/server.rb:295:in `block in start_thread'

You'll notice that there are a lot of lines that use a method 'call'.  This is a hint that the line comes from Rack middleware.  Middleware sits as a sort of filter between the web request coming in as flat text and the structured calls that hit your rails application.  The default rails stack has dozens of layers of middleware.  Each middleware uses a method, 'call', that then pushes the execution to the next middleware to be used.  There is a rake command to inspect your current middleware configuration.

    # rake middleware

    use Rack::Sendfile
    use ActionDispatch::Static
    use Rack::Lock
    use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007fa9c9f4f798>
    use Rack::Runtime
    use Rack::MethodOverride
    use ActionDispatch::RequestId
    use Rails::Rack::Logger
    use ActionDispatch::ShowExceptions
    use ActionDispatch::DebugExceptions
    use ActionDispatch::RemoteIp
    use ActionDispatch::Reloader
    use ActionDispatch::Callbacks
    use ActiveRecord::Migration::CheckPending
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    use ActiveRecord::QueryCache
    use ActionDispatch::Cookies
    use ActionDispatch::Session::CookieStore
    use ActionDispatch::Flash
    use ActionDispatch::ParamsParser
    use Rack::Head
    use Rack::ConditionalGet
    use Rack::ETag
    run UninhabitedMan::Application.routes

You can actually match up each middleware given in the output above with a line in the stack trace.  Notice that the final call is in DebugExceptions, meaning that execution in this thread didn't get to the middleware beneath it (RemoteIp, Reloader, Callbacks, ...).

You can trace the code through those different middlewares by opening up the versions of the gems that live on your systems.  I use bundler, so I can call

    bundle show actionpack

to print out the path on my current system to the `actionpack` version in my app's bundle.  To load it into the text editor of my choice, like Textmate, I can use the following command.

    bundle show actionpack | xargs mate

Unfortunately, snooping around in different middlewares doesn't reveal much about any of our three questions above.

### What's requesting the files?

We've sort of ruled out using the stack trace as a hint.  The next place I like to check are the gems.  Since the error has to do with assets (javascript and/or CSS files), it could have to do with any gems I have that add or manipulate assets.

It turns out that I had some dependency issues with my `sass-rails` gem.  Updating the versions got rid of most of the errors that I was seeing.

However, I still wasn't getting around the request for the ie-workaround js file shown in the stack trace above.  Some further inspection revealed two things.  For one, I am very dumb.  Second, there are sometimes interesting dependency problems in gems that include js and css asset files.

### The cause of the problem

To get things off the ground for my blog, I used a bootstrap template for blogs: <a href="http://getbootstrap.com">Bootstrap Template</a> by <a href="https://twitter.com/mdo">@mdo</a>.  In the layout that I took, there was a request for the missing file:

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>

This is where I was dumb - I should understand what javascript is being included in any code I use.

Since the template that I used was linked to from the bootstrap page, it's pretty safe to assume that the workaround linked in the template ships with the default bootstrap javascript.  And it turns out, <a href="https://github.com/twbs/bootstrap/commits/master/docs/assets/js/ie10-viewport-bug-workaround.js"> it is in the default bootstrap distribution</a>, but it isn't a file that is included in the `bootstrap-sass` ruby gem.  So the lesson here is: __gems that package assets into your app may not include files that are used by templates__.  To fix this, either pull the file into your `app/assets/javascripts` folder, or delete the `<script src...` line from the template.  I chose to pull the file into my app.


## Conclusion

1. Be careful about ignoring the unobtrusive errors about missing js or css files.

2. One method of fixing them is to make sure that the versions of any gems that inject assets into your app are correct and up to date.

3. Do a quick search-through-project (Cmd+Shift+F in Sublime Text) for the file in question to make sure you don't have code in your views requiring that file if it isn't in your app.
