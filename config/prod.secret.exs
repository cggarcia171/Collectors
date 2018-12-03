use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :rumbl, RumblWeb.Endpoint,
  secret_key_base: "WhKFu8ZFqrln9MxVmG4HYxjgxAd1H8Jz9A0YdnK68u9Hza+VQpqW5Bq6blz5+vuG"

# Configure your database
config :rumbl, Rumbl.Repo,
  username: "cggarcia171",
  password: "",
  database: "rumbl_prod",
  pool_size: 15
