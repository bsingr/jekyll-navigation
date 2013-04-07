require "jekyll-navigation/version"
require "liquid"

module JekyllNavigation
  class Navigation < Struct.new(:context, :level)
    def display?
      !render.empty?
    end

    def render
      pages.map do |page|
        css = (current_page["url"] == page["url"] ||
               navigation_parent_for(current_page) == page["url"]) ? "class='active'" : ""
        %Q{<li #{css}><a href=".#{page["url"]}">#{navigation_title_for(page)}</a></li>}
      end.join("\n")
    end

  private

    def navigation_title_for page
      if page["navigation"] && page["navigation"]["title"]
        page["navigation"]["title"]
      else
        page["title"] || File.basename(page["name"], File.extname(page["name"]))
      end
    end

    def navigation_parent_for page
      if page["navigation"] && page["navigation"]["parent"]
        page["navigation"]["parent"]
      else
        nil
      end
    end

    def navigation_order_for page
      if page["navigation"] && page["navigation"]["order"]
        page["navigation"]["order"]
      else
        -1
      end
    end

    def navigation_exclude_for page
      if page["navigation"] && page["navigation"]["exclude"]
        page["navigation"]["exclude"] == true
      else
        false
      end
    end

    def current_page
      context["page"]
    end

    def all_pages
      context["site"]["pages"].map do |page|
        page.data.merge("url" => page.url, "name" => page.name)
      end
    end

    def pages
      all_pages.map do |page|
        next if navigation_exclude_for(page)
        page_parent = navigation_parent_for(page)
        if level == "root" &&
          page_parent == nil # on the root level there is no parent
          page
        elsif level == "sub" &&
          page_parent != nil && # on the sub level there must be a parent
          (
            page_parent == navigation_parent_for(current_page) || # either the page shares a common parent
            page_parent == current_page["url"] # or the current page is the parent
          )
          page
        end
      end.compact.sort_by do |page|
        navigation_order_for(page)
      end
    end
  end

  class NavigationControllerTag < Liquid::Block
    def initialize(tag_name, level, tokens)
      super
      @level = level.to_s.strip
    end

    def render(context)
      navigation = Navigation.new(context, @level)
      
      if navigation.display?
        super
      else
        ""
      end
    end
  end

  class NavigationTag < Liquid::Tag
    def initialize(tag_name, level, tokens)
      super
      @level = level.to_s.strip
    end

    def render(context)
      navigation = Navigation.new(context, @level)
      navigation.render
    end
  end

  Liquid::Template.register_tag('if_navigation', NavigationControllerTag)
  Liquid::Template.register_tag('navigation', NavigationTag)
end
