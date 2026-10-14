# Installation

This library is distributed as a rubygem.

```ruby
# Gemfile

gem 'umts-auth'
```

OmniAuth is configured automatically in an initializer, but you must configure your own oauth credentials. These
are automatically read via the `creds` API.

Define them in your credentials...

```yml
entra_id:
  client_id: "YOUR_CLIENT_ID"
  client_secret: "YOUR_CLIENT_SECRET"
```

Or in your environment...

```dotenv
ENTRA_ID__CLIENT_ID="YOUR_CLIENT_ID"
ENTRA_ID__CLIENT_SECRET="YOUR_CLIENT_SECRET"
```

And providers will be automatically set up to route login and logout requests to `session#create` and
`sessions#destroy`.

Now define your controller and include the base authentication logic.

```ruby
# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  include UMTS::Authentication
end
```
