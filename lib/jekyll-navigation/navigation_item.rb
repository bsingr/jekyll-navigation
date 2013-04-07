module JekyllNavigation
  class AbstractNavigationItem < Struct.new(:page)
    def [] key
      page[key]
    end

    def title
      fetch_navigation_property('title') do
        self["title"] || File.basename(self["name"], File.extname(self["name"]))
      end
    end

    def parent
      fetch_navigation_property('parent') { nil }
    end

    def order
      fetch_navigation_property('order') { -1 }
    end

    def exclude?
      fetch_navigation_property('exclude') { false }
    end

  private

    def fetch_navigation_property key, found = nil
      if self["navigation"] && self["navigation"][key]
        self["navigation"][key]
      else
        yield
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
end
