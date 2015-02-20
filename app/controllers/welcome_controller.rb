class WelcomeController < ApplicationController

  def index
    @posts = Post.order('created_at desc').all
  end

end
