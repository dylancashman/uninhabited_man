module PostsHelper
  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(
                            Redcarpet::Render::HTML.new(prettify: true, 
                                                        link_attributes: { target: '_blank' } ), 
                            autolink: true, 
                            tables: true)
  end
end
