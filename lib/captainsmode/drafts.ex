defmodule Captainsmode.Drafts do
  @moduledoc """
  The Drafts context.
  """
  import Ecto.Changeset

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
end
