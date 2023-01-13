defmodule Squawk.Repo do
  use Ecto.Repo,
    otp_app: :squawk,
    adapter: Ecto.Adapters.Postgres
end
