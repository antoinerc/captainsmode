defmodule Captainsmode.Heroes.Hero do
  use Ecto.Schema
  import Ecto.Changeset

  schema "heroes" do
    field :json_id, :integer
    field :img, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(hero, attrs) do
    hero
    |> cast(attrs, [:json_id, :name, :img])
    |> validate_required([:json_id, :name, :img])
  end
end
