defmodule Captainsmode.DraftState do
  alias Captainsmode.Heroes.Hero

  @type side :: :radiant | :dire
  @type status :: :pending | :ongoing
  @type phase :: {atom(), integer(), Hero.id()}

  @type choice :: {side, %Captainsmode.Heroes.Hero{}}
  @type participants_sides :: %{radiant: String.t(), dire: String.t()}

  @type t :: %__MODULE__{
          id: String.t(),
          participants: list(String.t()),
          participants_sides: participants_sides(),
          status: status(),
          side_turn: side(),
          radiant_choices: [phase()],
          dire_choices: [phase()],
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
    side_turn: :radiant,
    current_phase: 1,
    radiant_choices: [
      %{type: :ban, order: 1, hero: nil},
      %{type: :ban, order: 3, hero: nil},
      %{type: :pick, order: 5, hero: nil},
      %{type: :pick, order: 7, hero: nil},
      %{type: :ban, order: 9, hero: nil},
      %{type: :ban, order: 11, hero: nil},
      %{type: :ban, order: 13, hero: nil},
      %{type: :pick, order: 16, hero: nil},
      %{type: :pick, order: 18, hero: nil},
      %{type: :ban, order: 19, hero: nil},
      %{type: :ban, order: 21, hero: nil},
      %{type: :pick, order: 23, hero: nil},
    ],
    dire_choices: [
      %{type: :ban, order: 2, hero: nil},
      %{type: :ban, order: 4, hero: nil},
      %{type: :pick, order: 6, hero: nil},
      %{type: :pick, order: 8, hero: nil},
      %{type: :ban, order: 10, hero: nil},
      %{type: :ban, order: 12, hero: nil},
      %{type: :ban, order: 14, hero: nil},
      %{type: :pick, order: 15, hero: nil},
      %{type: :pick, order: 17, hero: nil},
      %{type: :ban, order: 20, hero: nil},
      %{type: :ban, order: 22, hero: nil},
      %{type: :pick, order: 24, hero: nil}
    ],
    pick_timer: 30,
    ban_timer: 35,
    banned: [],
    picked: []
  ]
end
