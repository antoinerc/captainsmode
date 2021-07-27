defmodule Captainsmode.Drafts do
  @moduledoc """
  The Drafts context.
  """
  import Ecto.Changeset

  alias Captainsmode.DraftState

  defmodule IncomingPlayerInfo do
    @enforce_keys [:username, :participants_count, :already_joined]
    defstruct [:username, :participants_count, :already_joined]

    @type t :: %__MODULE__{
            username: String.t(),
            participants_count: integer(),
            already_joined: boolean()
          }
  end

  defmodule ChangeSideInfo do
    @enforce_keys [:username, :side]
    defstruct [:username, :side]

    @type t :: %__MODULE__{
            username: String.t(),
            side: DraftState.side()
          }
  end

  def change_configuration(
        changeset,
        params \\ %{
          timer_type: "default",
          pick_timer: 30,
          ban_timer: 35,
          reserve_timer: 130
        }
      ) do
    types = %{
      timer_type: :string,
      pick_timer: :integer,
      ban_timer: :integer,
      reserve_timer: :integer
    }

    {changeset, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:timer_type])
    |> validate_inclusion(:timer_type, ["default", "custom"])
    |> validate_timers()
  end

  defp validate_timers(changeset) do
    case changeset.changes.timer_type === "custom" do
      true ->
        changeset
        |> validate_number(:pick_timer, greater_than_or_equal_to: 0)
        |> validate_number(:ban_timer, greater_than_or_equal_to: 0)
        |> validate_number(:reserve_timer, greater_than_or_equal_to: 0)

      false ->
        changeset
    end
  end

  @spec join(DraftState.t(), String.t()) ::
          {:ok, DraftState.t()} | {:error, {atom(), DraftState.t()}}
  def join(draft_state, player_name) do
    participants_count = length(draft_state.participants)
    is_already_in_game = Enum.any?(draft_state.participants, fn x -> x == player_name end)

    do_join(draft_state, %IncomingPlayerInfo{
      username: player_name,
      participants_count: participants_count,
      already_joined: is_already_in_game
    })
  end

  @spec change_side(DraftState.t(), String.t(), String.t()) ::
          {:ok, DraftState.t()} | {:error, {atom(), DraftState.t()}}
  def change_side(draft_state, player_name, side) do
    side_atom =
      case side do
        "radiant" -> :radiant
        "dire" -> :dire
      end

    change_side_info = %ChangeSideInfo{username: player_name, side: side_atom}
    do_change_side(draft_state, change_side_info)
  end

  def pick_hero(
        %{phases: phases} = draft_state,
        hero_id,
        username
      ) do
    {next_slot, next_slot_index} = get_next_open_slot(phases)

    with {:ok, _} <- validate_current_side_picking(draft_state, next_slot, username),
         {:ok, _} <- validate_hero_not_taken(draft_state, hero_id) do
      {:ok,
       %DraftState{
         draft_state
         | phases: List.update_at(phases, next_slot_index, &%{&1 | hero: hero_id})
       }}
    else
      {:error, reason} ->
        {:error, {reason, draft_state}}
    end
  end

  def is_draft_session_full?(%DraftState{participants: participants}),
    do: length(participants) == 2

  defp do_join(draft_state, %IncomingPlayerInfo{
         username: _,
         participants_count: 2,
         already_joined: false
       }) do
    {:error, {:session_full, draft_state}}
  end

  defp do_join(draft_state, %IncomingPlayerInfo{
         username: _,
         participants_count: _,
         already_joined: true
       }) do
    {:ok, draft_state}
  end

  defp do_join(draft_state, %IncomingPlayerInfo{
         username: username,
         participants_count: _,
         already_joined: _
       }) do
    {:ok, %DraftState{draft_state | participants: [username | draft_state.participants]}}
  end

  defp do_change_side(draft_state, %ChangeSideInfo{username: username, side: :radiant}) do
    case draft_state.participants_sides do
      %{radiant: nil, dire: ^username} ->
        {:ok,
         %DraftState{
           draft_state
           | participants_sides: %{
               draft_state.participants_sides
               | :radiant => username,
                 :dire => nil
             }
         }}

      %{radiant: nil, dire: _} ->
        {:ok,
         %DraftState{
           draft_state
           | participants_sides: %{draft_state.participants_sides | :radiant => username}
         }}

      _ ->
        {:error, {:side_full, draft_state}}
    end
  end

  defp do_change_side(draft_state, %ChangeSideInfo{username: username, side: :dire}) do
    case draft_state.participants_sides do
      %{dire: nil, radiant: ^username} ->
        {:ok,
         %DraftState{
           draft_state
           | participants_sides: %{
               draft_state.participants_sides
               | :dire => username,
                 :radiant => nil
             }
         }}

      %{dire: nil, radiant: _} ->
        {:ok,
         %DraftState{
           draft_state
           | participants_sides: %{draft_state.participants_sides | :dire => username}
         }}

      _ ->
        {:error, {:side_full, draft_state}}
    end
  end

  defp get_next_open_slot(phases) do
    phases
    |> Enum.with_index()
    |> Enum.find(fn {phase, _} -> phase.hero == nil end)
  end

  defp get_player_side(participants_sides, username) do
    case participants_sides do
      %{radiant: ^username, dire: _} -> :radiant
      _ -> :dire
    end
  end

  defp validate_hero_not_taken(draft_state, hero) do
    case Enum.any?(draft_state.phases, fn phase -> phase.hero == hero end) do
      true -> {:error, :already_picked}
      _ -> {:ok, draft_state}
    end
  end

  defp validate_current_side_picking(draft_state, phase, username) do
    player_side = get_player_side(draft_state.participants_sides, username)

    case phase.side == player_side do
      true -> {:ok, draft_state}
      _ -> {:error, :not_side_turn}
    end
  end
end
