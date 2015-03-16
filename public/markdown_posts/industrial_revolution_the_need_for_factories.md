# Industrial Revolution: The need for factories.

In building this blog, I wanted to take full advantage of it being a [greenfield project](http://en.wikipedia.org/wiki/Greenfield_project).  I wanted to build something from scratch with no deadlines or time restrictions with the barest technologies, only taking on new technologies when I felt the need justified them.  I originally started with [Sinatra](http://www.sinatrarb.com/) but I found that there was too much customization needed to have the blog interface with a database.  The early iterations of the blog were vanilla rails apps with a few basic gems, like Devise and Paperclip, to get some basic functionality in.  I don't want to spend time doing a custom authentication system; [Devise](https://github.com/plataformatec/devise), the industry standard, does a great job and its makers are much more knowledgable about security than I am.  Likewise, [Paperclip](https://github.com/thoughtbot/paperclip), the first gem I ever used when I first learned Rails, fills all of my needs and saves me a lot of time and thought.

## Testing

In larger rails projects, you'll often see a large `group :test` in the project's Gemfile.  I'd almost always used `rspec`, along with something to test the frontend like `capybara`, and then something for factories, like Thoughtbot's excellent [`factory_girl`](https://github.com/thoughtbot/factory_girl).  You might also include some extra matchers or you might put in libraries that maintain the testing database in a certain state.  I never asked myself the question of why those gems were needed, though.  They add weight to your test suite and hurt the portability of your code.  I figured I'd try to give it a go without the usual set of gems and see what I missed the most.

The default Rails configuration, though, starts you off with [`minitest`](https://github.com/seattlerb/minitest), so I decided I would stick with it; the rails core team likes it, so there must be something to it!  So far, it's working just fine.  I allowed myself to use the spec-style test declarations, since that seems to be a popular usage of minitest.

I started running into problems when I began testing a new section of the blog that will be up soon - Site Iterations.  I want to keep track of major upgrades to this blog with some screenshots so that someone visiting the site can view the changes it went through as it was developed.  Since the posts on this blog are often documenting changes made to the blog itself, I wanted posts to automatically attach themselves to the most recent Site Iteration, so that a Site Iteration knew which blog posts were published under it's 'reign'.

The test looked something like this.

    before do
      @post ||= Post.new
    end

    # ... other tests ... #

    test 'sets site_iteration after creation' do
      # setup
      site_iteration = SiteIteration.create!
      @post.save!

      assert_equal site_iteration, @post.site_iteration

      # knockdown
      site_iteration.delete!
      @post.delete!
    end

The first thing you might notice is the test has a 'setup' phase used to prepare the environment, and then it has a 'knockdown' phase used to restore the environment, so that running the test doesn't change the state of the test database.  That's awkward and takes a lot of code, but I can live with it.

A larger problem that I ran into, though, is that SiteIteration has validations that require presence of some of its attributes.  I could switch to the SiteIterationTest file and copy and paste the attributes that make it valid, but then I've duplicated code; if any of the validations change, I would have to change both of these tests.  You can see that this problem explodes the more models you have.  This could be an argument that relying on this automatic attachment is a code smell, and maybe if this were for a larger project, I might refactor into service objects.  For now, though, I like the function of the code this is testing, and I think adding factories is justified.

In testing terms, a factory's job is to hold the information of what is needed to build a valid instance of a model.  I much prefer keeping that information in the factory and not across multiple tests.

## Conclusion

Factories can find their justification Even in a small new rails project.  They save you from duplicating code and help you adhere to the single responsibility principle: there needs to be a place to define what a valid instance of a Model looks like.
