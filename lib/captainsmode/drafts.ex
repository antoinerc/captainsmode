defmodule Captainsmode.Drafts do
  @moduledoc """
  The Drafts context.
  """
  import Ecto.Changeset

  alias Captainsmode.DraftState

  defmodule IncomingPlayerInfo do
    @enforce_keys [:username, :participants_count, :already_joined]
    defstruct [:username, :participants_count, :already_joined]

    @type t :: %IncomingPlayerInfo{
            username: String.t(),
            participants_count: integer(),
            already_joined: boolean()
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
    case String.equivalent?(changeset.changes.timer_type, 'custom') do
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

  defp do_join(draft_state, %IncomingPlayerInfo{
         username: _,
         participants_count: 2,
         already_joined: _
       }) do
    {:error, {:session_full, draft_state}}
  end

  defp do_join(draft_state, %IncomingPlayerInfo{
         username: _,
         participants_count: _,
         already_joined: true
       }) do
    {:error, {:alread_joined, draft_state}}
  end

  defp do_join(draft_state, %IncomingPlayerInfo{
    username: username,
    participants_count: _,
    already_joined: _
  }) do
    {:ok, %DraftState{draft_state | participants: [username | draft_state.participants]}}
  end
end
