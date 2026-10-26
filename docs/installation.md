# Installation

This library is distributed as a rubygem.

```ruby
# Gemfile

gem 'umts-auth'
```

---

Define your Entra ID client in your credentials...

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

---

Ensure you have a `User` model with unique string column named `entra_uid`.

---

Set up your `Current` model.

```ruby
# app/models/current.rb

class Current < ActiveSupport::CurrentAttributes
  include UMTS::Auth::Current
end
```

---

Set up your `ApplicationController`.

```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  include UMTS::Auth::Controller
end
```

---

Set up your `SessionsController`.

```ruby
# app/controllers/sessions_controller.rb

class SessionsController < UMTS::Auth::SessionsController
end
```

---

Set up your `ApplicationPolicy`.

```ruby
# app/policies/application_policy.rb

class ApplicationPolicy < ActionPolicy::Base
  include UMTS::Auth::Policy
end
```

---

Include rspec helpers.

```ruby
# spec/rails_helper.rb

require 'umts/auth/rspec'
```
