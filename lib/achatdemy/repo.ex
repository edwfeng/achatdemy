defmodule Achatdemy.Repo do
  use Ecto.Repo,
    otp_app: :achatdemy,
    adapter: Ecto.Adapters.Postgres
end
