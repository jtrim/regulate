Regulate
===========
Rails 3 engine that provides a Git backed CMS that allows for an admin to define editable regions in a page view.


### Why
We often have applications that need fairly basic CMS solutions but the
client may not have someone on staff that knows HTML.  We needed a CMS
that wasn't bloated, lived as an engine, allowed us to regulate what
parts of a page could be editable, and we wanted it to be Git backed so
we could have version control over the edits. We also designed regulate
to work with any authentication / authorization service.

## How it works
Video coming soon!

### Quick Start

Add regulate to your Rails 3 Gemfile

    gem "regulate"

    bundle install

Install the initializer

    rails g regulate:mount_up

You MUST edit the initializer located in `config/initializers/regulate.rb`.  Please read the comments located in the regulate initializer for details on configuring regulate to work with your authentication and authorization systems and for defining custom routes. NOTHING works until you do this!


### Options

More than likely you will want to customize the views in regulate.  To copy the view files, javascript in the admin and the git repo config yaml file simply run...

    rails g regulate:strap

The `strap` generator will copy the following files into your Rails application like so.

    create  app/views/regulate
    create  app/views/regulate/admin/pages/_form.html.haml
    create  app/views/regulate/admin/pages/edit.html.haml
    create  app/views/regulate/admin/pages/index.html.haml
    create  app/views/regulate/admin/pages/new.html.haml
    create  app/views/regulate/pages/show.html.haml
    create  public/javascripts/regulate_admin.js
    create  config/regulate.yml



### Issues

Please report issues to the [Regulate issue tracker](http://github.com/quickleft/regulate/issues/).


### Patches/Pull Requests

* Fork it.
* Add tests for it.
* Make your changes.
* Commit.
* Send a pull request.


### Thanks

Thanks to mojombo for writing grit and gollum. We use grit to talk to Git and reading the source of gollum was a major help. Thanks to brennandunn for inspiring
us with rack-cms. Thanks to josevalim for writing devise, it is an excellent example of a Rails 3 engine. Thanks to Nate Dogg and Warren G for insipiring the name.


### Copyright

Copyright (c) 2011 Quick Left. We regulate any stealing of his property (actually we don't it's MIT). See LICENSE for details.

Regulators we regulate any stealing of his property and we damn good too But you can't be any geek off the street, gotta be handy with the steel if you know what I mean, earn your keep!


REGULATORS!!! MOUNT UP!

