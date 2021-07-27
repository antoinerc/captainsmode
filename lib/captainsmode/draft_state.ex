defmodule Captainsmode.DraftState do
  alias Captainsmode.Heroes.Hero

  @type side :: :radiant | :dire
  @type status :: :pending | :ongoing
  @type phase :: {atom(), integer(), side(), Hero.id()}

  @type choice :: {side, %Captainsmode.Heroes.Hero{}}
  @type participants_sides :: %{radiant: String.t(), dire: String.t()}

  @type t :: %__MODULE__{
          id: String.t(),
          participants: list(String.t()),
          participants_sides: participants_sides(),
          status: status(),
          phases: [phase()],
          pick_timer: integer(),
          ban_timer: integer(),
          banned: list(choice()),
          picked: list(choice())
        }

  @enforce_keys [:id]
  defstruct [
    :id,
    participants: [],
    participants_sides: %{radiant: nil, dire: nil},
    status: :pending,
    phases: [
      %{type: :ban, order: 1, side: :radiant, hero: nil},
      %{type: :ban, order: 2, side: :dire, hero: nil},
      %{type: :ban, order: 3, side: :radiant, hero: nil},
      %{type: :ban, order: 4, side: :dire, hero: nil},
      %{type: :pick, order: 5, side: :radiant, hero: nil},
      %{type: :pick, order: 6, side: :dire, hero: nil},
      %{type: :pick, order: 7, side: :radiant, hero: nil},
      %{type: :pick, order: 8, side: :dire, hero: nil},
      %{type: :ban, order: 9, side: :radiant, hero: nil},
      %{type: :ban, order: 10, side: :dire, hero: nil},
      %{type: :ban, order: 11, side: :radiant, hero: nil},
      %{type: :ban, order: 12, side: :dire, hero: nil},
      %{type: :ban, order: 13, side: :radiant, hero: nil},
      %{type: :ban, order: 14, side: :dire, hero: nil},
      %{type: :pick, order: 15, side: :dire, hero: nil},
      %{type: :pick, order: 16, side: :radiant, hero: nil},
      %{type: :pick, order: 17, side: :dire, hero: nil},
      %{type: :pick, order: 18, side: :radiant, hero: nil},
      %{type: :ban, order: 19, side: :radiant, hero: nil},
      %{type: :ban, order: 20, side: :dire, hero: nil},
      %{type: :ban, order: 21, side: :radiant, hero: nil},
      %{type: :ban, order: 22, side: :dire, hero: nil},
      %{type: :pick, order: 23, side: :radiant, hero: nil},
      %{type: :pick, order: 24, side: :dire, hero: nil}
    ],
    pick_timer: 30,
    ban_timer: 35,
    banned: [],
    picked: []
  ]
end
