defmodule Captainsmode.Repo do
  use Ecto.Repo,
    otp_app: :captainsmode,
    adapter: Ecto.Adapters.Postgres
end
