defmodule EbnoBeta.Repo do
  use Ecto.Repo,
    otp_app: :ebno_beta,
    adapter: Ecto.Adapters.Postgres
end
