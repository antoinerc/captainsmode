defmodule Captainsmode.Drafts do
  @moduledoc """
  The Drafts context.
  """
  import Ecto.Changeset

  def create_configuration_changeset(params \\ %{side: "random", timer_type: "default"}) do
    data = %{}

    types = %{
      side: :string,
      timer_type: :string,
      pick_timer: :integer,
      ban_timer: :integer,
      reserve_timer: :integer
    }

    {data, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:side, :timer_type])
    |> validate_inclusion(:side, ["radiant", "dire", "random"])
    |> validate_inclusion(:timer_type, ["default", "custom"])
    |> validate_timers(params.timer_type)
  end

  def update_configuration_changeset(changeset, params \\ %{side: "random", timer_type: "default"} ) do
    types = %{
      side: :string,
      timer_type: :string,
      pick_timer: :integer,
      ban_timer: :integer,
      reserve_timer: :integer
    }

    {changeset, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:side, :timer_type])
    |> validate_inclusion(:side, ["radiant", "dire", "random"])
    |> validate_inclusion(:timer_type, ["default", "custom"])
    |> validate_timers(params.timer_type)
  end

  defp validate_timers(changeset, timer_type) do
    case timer_type == "custom" do
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
