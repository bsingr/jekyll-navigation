# Navigation for Jekyll

This gem provides [Jekyll](http://github.com/mojombo/jekyll) tags to render navigation lists.

## Usage

Your pages:

    - home.md
    - portfolio.md
    - contact.md
    - imprint.md

In your layout.html:

    <ul class='nav'>
      {% navigation root %}
    </ul>

Output for portfolio.html:

    <ul class='nav'>
      <li><a href="/home.html">home</a></li>
      <li class='active'><a href="/portfolio.html">portfolio</a></li>
      <li><a href="/contact.html">contact</a></li>
      <li><a href="/imprint.html">imprint</a></li>
    </ul>

## Installation

### With Bundler

Add this line to your application's Gemfile:

    gem 'jekyll-navigation'

And then execute:

    $ bundle

You'll need this plugin to load the Gemfile gems in Jekyll:

    # _plugins/bundler.rb
    require 'bundler/setup'
    Bundler.require(:default)

### Plain gem

You can also use this gem by install it yourself as:

    $ gem install jekyll-navigation

Then add this plugin:

    # _plugins/navigation.rb
    require 'jekyll-navigation'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licencse

See [LICENSE.txt](LICENSE.txt)
