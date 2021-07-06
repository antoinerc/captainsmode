defmodule Captainsmode.DraftState do
  @type side :: :radiant | :dire
  @type status :: :pending | :ongoing
  @type phase ::
          {:first_ban, 2}
          | {:first_pick, 2}
          | {:second_ban, 3}
          | {:second_pick, 2}
          | {:third_ban, 2}
          | {:third_pick, 1}
  @type choice :: {side, %Captainsmode.Heroes.Hero{}}
  @type participants_sides :: %{radiant: String.t(), dire: String.t()}

  @type t :: %__MODULE__{
          id: String.t(),
          participants: list(String.t()),
          participants_sides: participants_sides(),
          status: status(),
          side_turn: side(),
          phase: phase(),
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
    phase: {:first_ban, 2},
    pick_timer: 30,
    ban_timer: 35,
    banned: [],
    picked: []
  ]
end
