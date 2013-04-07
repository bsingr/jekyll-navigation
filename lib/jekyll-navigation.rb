require "jekyll-navigation/version"
require "liquid"

module JekyllNavigation
  class AbstractNavigationItem < Struct.new(:page)
    def [] key
      page[key]
    end

    def title
      if self["navigation"] && self["navigation"]["title"]
        self["navigation"]["title"]
      else
        self["title"] || File.basename(self["name"], File.extname(self["name"]))
      end
    end

    def parent
      if self["navigation"] && self["navigation"]["parent"]
        self["navigation"]["parent"]
      else
        nil
      end
    end

    def order
      if self["navigation"] && self["navigation"]["order"]
        self["navigation"]["order"]
      else
        -1
      end
    end

    def exclude?
      if self["navigation"] && self["navigation"]["exclude"]
        self["navigation"]["exclude"] == true
      else
        false
      end
    end
  end

  class CurrentNavigationItem < AbstractNavigationItem
    
  end

  class NavigationItem < AbstractNavigationItem
    def data
      page.data.merge("url" => page.url, "name" => page.name)
    end

    def [] key
      data[key]
    end
  end

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
