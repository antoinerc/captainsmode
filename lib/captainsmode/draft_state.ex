defmodule Captainsmode.DraftState do
  alias Captainsmode.Heroes.Hero

  @type side :: :radiant | :dire
  @type status :: :pending | :ongoing
  @type phase :: {side, atom(), integer(), Hero.id()}

  @type choice :: {side, %Captainsmode.Heroes.Hero{}}
  @type participants_sides :: %{radiant: String.t(), dire: String.t()}

  @type t :: %__MODULE__{
          id: String.t(),
          participants: list(String.t()),
          participants_sides: participants_sides(),
          status: status(),
          side_turn: side(),
          current_phase: integer(),
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
    side_turn: :radiant,
    current_phase: 4,
    phases: [
      %{side: :radiant, type: :ban, order: 1, hero: nil},
      %{side: :dire, type: :ban, order: 2, hero: nil},
      %{side: :radiant, type: :ban, order: 3, hero: nil},
      %{side: :dire, type: :ban, order: 4, hero: nil},
      %{side: :radiant, type: :pick, order: 5, hero: nil},
      %{side: :dire, type: :pick, order: 6, hero: nil},
      %{side: :dire, type: :pick, order: 7, hero: nil},
      %{side: :radiant, type: :pick, order: 8, hero: nil},
      %{side: :radiant, type: :ban, order: 9, hero: nil},
      %{side: :dire, type: :ban, order: 10, hero: nil},
      %{side: :radiant, type: :ban, order: 11, hero: nil},
      %{side: :dire, type: :ban, order: 12, hero: nil},
      %{side: :radiant, type: :ban, order: 13, hero: nil},
      %{side: :dire, type: :ban, order: 14, hero: nil},
      %{side: :dire, type: :pick, order: 15, hero: nil},
      %{side: :radiant, type: :pick, order: 16, hero: nil},
      %{side: :dire, type: :pick, order: 17, hero: nil},
      %{side: :radiant, type: :pick, order: 18, hero: nil},
      %{side: :radiant, type: :ban, order: 19, hero: nil},
      %{side: :dire, type: :ban, order: 20, hero: nil},
      %{side: :radiant, type: :ban, order: 21, hero: nil},
      %{side: :dire, type: :ban, order: 22, hero: nil},
      %{side: :radiant, type: :pick, order: 23, hero: nil},
      %{side: :dire, type: :pick, order: 24, hero: nil}
    ],
    pick_timer: 30,
    ban_timer: 35,
    banned: [],
    picked: []
  ]
end
