defmodule Captainsmode.Repo.Migrations.CreateHeroes do
  use Ecto.Migration

  def change do
    create table(:heroes) do
      add :json_id, :integer
      add :name, :string
      add :img, :string

      timestamps()
    end

  end
end
