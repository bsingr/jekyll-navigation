require "jekyll-navigation/version"
require "jekyll-navigation/navigation_item"
require "jekyll-navigation/navigation"
require "liquid"

module JekyllNavigation
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
