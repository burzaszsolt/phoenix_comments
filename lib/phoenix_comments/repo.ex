defmodule PhoenixComments.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_comments,
    adapter: Ecto.Adapters.Postgres
end
