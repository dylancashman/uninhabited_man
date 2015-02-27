class WelcomeController < ApplicationController

  def index
    @current_post = Post.order('created_at desc').first
  end

end
