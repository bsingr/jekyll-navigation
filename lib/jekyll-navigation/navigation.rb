module JekyllNavigation
  class Navigation < Struct.new(:context, :level)
    def display?
      !render.empty?
    end

    def render
      pages.map do |page|
        css = (current_page["url"] == page["url"] ||
               current_page.parent == page["url"]) ? " class='active'" : ""
        %Q{<li#{css}><a href=".#{page["url"]}">#{page.title}</a></li>}
      end.join("\n")
    end

  private

    def current_page
      CurrentNavigationItem.new context["page"]
    end

    def all_pages
      context["site"]["pages"].map do |page|
        NavigationItem.new page
      end
    end

    def pages
      all_pages.map do |page|
        next if page.exclude?
        if level == "root" &&
          page.parent == nil # on the root level there is no parent
          page
        elsif level == "sub" &&
          page.parent != nil && # on the sub level there must be a parent
          (
            page.parent == current_page.parent || # either the page shares a common parent
            page.parent == current_page["url"] # or the current page is the parent
          )
          page
        end
      end.compact.sort_by &:order
    end
  end
end