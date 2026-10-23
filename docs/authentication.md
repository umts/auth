# Authentication

The entra `tenant_id` is programmatically available at `UMTS::Auth.tenant_id`.

You can add a callback to the login action through `after_login` which is an alias
for `after_action only: :create`.
