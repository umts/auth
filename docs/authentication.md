# Authentication

Users are authenticated using OmniAuth pointed at Microsoft Entra ID through OmniAuth.

## Session Flow

OmniAuth is automatically configured via an initializer and a `SessionController` base class is provided that works
with it out of the box.

### Credentials

You must provision an app registration in Azure and provide a client_id/client_secret.

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

### Routes

The following routes are added to your application.

| Helper                          | Verb | Path                       | Action             |
| ------------------------------- | ---- | -------------------------- | ------------------ |
| `entra_login_path`              | GET  | `/auth/entra_id`           | omniauth           |
| `auth_callback_path(provider:)` | GET  | `/auth/:provider/callback` | `sessions#create`  |
| `logout_path`                   | POST | `/logout`                  | `sessions#destroy` |

### Session management

You must create your own `SessionsController`, but almost all functionality is provided by the
`UMTS::Auth::SessionController` base class.

```ruby
# app/controllers/sessions_controller.rb

class SessionsController < UMTS::Auth::SessionsController
end
```

#### Login

On login, the controller will store the following values in the session, if provided:

- `entra_uid`
- `entra_email`
- `entra_first_name`
- `entra_last_name`
- `entra_upn`

It will then attempt to redirect the user back to where they came from, with the `root_path` as a fallback.

If you need to hook into the login process (e.g. automatically create/sync user records on login), you can use the
`after_login` method (an alias for `after_action only: :create`).

```ruby
# app/controllers/sessions_controller.rb

class SessionsController < UMTS::Auth::SessionsController
  after_login do
    User.find_or_initialize_by(entra_uid: session[:entra_uid])
        .update!({ entra_upn: session[:entra_upn],
                   email: session[:entra_email],
                   first_name: session[:entra_first_name],
                   last_name: session[:entra_last_name] }.compact_blank)
  end
end
```

Only `entra_uid` is guaranteed to exist across all environments/providers, so guard accordingly.

#### Logout

On logout, the session keys set during login (and only those keys) will be cleared.

## Request Flow

Authentication logic is added globally to all requests via `UMTS::Auth::Controller`, which writes values to
your application's `Current` instance (requirements are covered by `UMTS::Auth::Current`).

```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  include UMTS::Auth::Controller
end

# app/models/current.rb

class Current < ActiveSupport::CurrentAttributes
  include UMTS::Auth::Current
end
```

For each request, if `session[:entra_uid]` is present, it will query and set any `User` with a matching `entra_uid`
column. Your `User` model needs to define this column, and it is best practice for it to be non-nullable and unique.

If a user is matched, it will be available through `Current.user` within your controllers and policies.

Further behavior is covered in the "Authorization" section.

### PaperTrail integration

`UMTS::Auth::Current` automatically integrates with `paper_trail` if it is installed by setting the whodunnit value
when `Current.user` is written to.

## Testing

RSpec helpers are provided by `UMTS::Auth::RSpec`.

```ruby
# spec/rails_helper.rb

require 'umts/auth/rspec'
```

Set `current_user` to control who is logged in. It defaults to `nil`.

```ruby
RSpec.describe 'Users' do
  let(:current_user) { create(:user) }
end
```

Request and system specs perform a mocked OmniAuth login. All other spec types set `Current.user` around the
example. If needed, you can use the `login_as` helper method to switch users mid-example.
