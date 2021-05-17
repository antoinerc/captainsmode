# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Captainsmode.Repo.insert!(%Captainsmode.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Captainsmode.Heroes.Hero

heroes_json_file = "#{__DIR__}/seeds/heroes.json"

with {:ok, body} <- File.read(heroes_json_file),
     {:ok, json} <- Jason.decode(body) do
  json
  |> Enum.map(fn {_, %{"localized_name" => name, "id" => json_id, "img" => img}} ->
    Captainsmode.Repo.insert!(%Hero{
      json_id: json_id,
      name: name,
      img: img
    })
  end)
else
  {:error, msg} ->
    IO.inspect(msg)
end
