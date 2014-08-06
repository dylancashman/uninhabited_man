require 'test_helper'

feature "Main Page" do 
  it "has content" do
    visit root_path
    page.must_have_content "Semi-conscious thoughts from a sort-of person."
    page.wont_have_content "Exception"
  end

  it "shows the newest blog post" do
    post = Post.create!(body: "Oh I wish I were an Oscar Meyer Weiner")

    visit root_path
    page.must_have_content "Oh I wish I were an Oscar Meyer Weiner"
  end
end