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

  def pick_hero(draft_state, hero_id) do
    case Enum.member?(draft_state.radiant_choices, %{hero: hero_id}) ||
           Enum.member?(draft_state.dire_choices, %{hero: hero_id}) do
      true ->
        {:error, {:hero_picker, draft_state}}

      _ ->
        is_radiant_turn =
          Enum.any?(draft_state.radiant_choices, fn choice ->
            choice.order == draft_state.current_phase
          end)

        case is_radiant_turn do
          true ->
            {:ok,
             %DraftState{
               draft_state
               | radiant_choices:
                   List.update_at(
                     draft_state.radiant_choices,
                     draft_state.current_phase,
                     &%{&1 | hero: hero_id}
                   ),
                   current_phase: draft_state.current_phase + 1
             }}

          false ->
            {:ok,
             %DraftState{
               draft_state
               | dire_choices:
                   List.update_at(
                     draft_state.dire_choices,
                     draft_state.current_phase,
                     &%{&1 | hero: hero_id}
                   ),
                   current_phase: draft_state.current_phase + 1

             }}
        end
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
end
