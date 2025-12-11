defmodule LiveVueWebsite.Repo do
  use Ecto.Repo,
    otp_app: :live_vue_website,
    adapter: Ecto.Adapters.SQLite3
end
