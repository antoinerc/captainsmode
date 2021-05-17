defmodule Captainsmode.GameState do
  @type side :: :radiant | :dire
  @type status :: :pending | :ongoing
  @type phase :: {:first_ban, 2} | {:first_pick, 2} | {:second_ban, 3} | {:second_pick, 2} | {:third_ban, 2} | {:third_pick, 1}

  @type t :: %__MODULE__{
    id: String.t(),
    status: status(),
    side_turn: side(),
    phase: phase(),
    pick_timer: integer(),
    ban_timer: integer(),
    banned: list(),
    picked: list()
  }

  @enforce_keys [:id]
  defstruct [
    :id,
    status: :pending,
    side_turn: :radiant,
    phase: {:first_ban, 2},
    pick_timer: 30,
    ban_timer: 35,
    banned: [],
    picked: []
  ]
end
