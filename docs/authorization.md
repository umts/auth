# Authorization

Authorization is handled by `ActionPolicy` and authorization control is handled globally by `UMTS::Auth::Controller`.

## Policies

Including `UMTS::Auth::Policy` in your base policy configures basee contexts and rule aliases.

```ruby
# app/policies/application_policy.rb

class ApplicationPolicy < ActionPolicy::Base
  include UMTS::Auth::Policy
end
```

The following context values are provided to every policy, and are populated automatically by `UMTS::Auth::Controller`.

| Context   | Value                                            |
| --------- | ------------------------------------------------ |
| `user`    | `Current.user`, (`nil` when nobody is logged in) |
| `request` | the current `ActionDispatch::Request`            |

| Rule      | Falls back to |
| --------- | ------------- |
| `create?` | `manage?`     |
| `new?`    | `create?`     |
| `update?` | `manage?`     |
| `edit?`   | `update?`     |

## Request Flow

Every action must manually call `authorize!` (enforced by `UMTS::Auth::Controller` through `verify_authorized`).

`UMTS::Auth::Controller` will then rescue from `ActionPolicy::Unauthorized` errors.

- If the user is not logged in (is missing a `session[:entra_uid]`)...
  - in production...
    - the user is automatically directed to Entra ID to log in.
  - in development...
    - a development login page is rendered (see below).
  - in test...
    - it responds with a 401 head.
- If the user is logged in...
  - in production...
    - it renders the rails 403 error page.
  - in development/test...
    - it reraises the `ActionPolicy::Unauthorized` error

### Development login

In development, a prestyled development login page is provided that allows you log in via entra (requires development
omniauth credentials) or from a predefined list of users.

The list of users is configurable, and each object must respond to `entra_uid` and `name`.

```ruby
# config/initializers/auth.rb

UMTS::Auth.development_login_users = lambda {
  { 'Admins' => User.where(admin: true), 'Regular' => User.where.not(admin: true) }
}
```

It defaults to `-> { { 'Users' => User.all } }`.
