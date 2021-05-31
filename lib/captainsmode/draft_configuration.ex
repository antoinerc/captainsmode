defmodule Captainsmode.Drafts.DraftConfiguration do
  defstruct [:timer_type, :pick_timer, :ban_timer, :reserve_timer]

  @type t :: %__MODULE__{
          timer_type: String.t(),
          pick_timer: Integer.t(),
          ban_timer: Integer.t(),
          reserve_timer: Integer.t()
        }

  @doc """
  Generates a new draft configuration
  """
  def new() do
    %__MODULE__{
      timer_type: "default",
      pick_timer: 30,
      ban_timer: 35,
      reserve_timer: 130
    }
  end

  def change(config, attrs \\ %{}) do
    {config, []}
    |> change_timer_values(attrs)
    |> change_timer_type(attrs)
    |> case do
      {config, []} -> {:ok, config}
      {config, errors} -> {:error, errors, config}
    end
  end

  defp change_timer_type({config, errors}, %{"timer_type" => "default"}) do
    {%{config | timer_type: "default"}, errors}
  end

  defp change_timer_type({config, errors}, %{"timer_type" => "custom"}) do
    {%{config | timer_type: "custom"}, errors}
  end

  defp change_timer_type({config, errors}, %{"timer_type" => _}) do
    {config, [{:timer_type, "not a valid timer type"} | errors]}
  end

  defp change_timer_values(config, %{
         "timer_type" => "custom",
         "pick_timer" => pick,
         "ban_timer" => ban,
         "reserve_timer" => reserve
       }) do
    config
    |> change_pick_timer(pick)
    |> change_ban_timer(ban)
    |> change_reserve_timer(reserve)
  end

  defp change_timer_values({config, errors}, _attrs), do: {config, errors}

  defp change_pick_timer({config, errors}, pick_timer) do
    if not is_integer(pick_timer) or pick_timer < 0 do
      {config, [{:pick_timer, "not a valid amount of seconds"} | errors]}
    end
  end

  defp change_ban_timer({config, errors}, ban_timer) do
    if not is_integer(ban_timer) or ban_timer < 0 do
      {config, [{:ban_timer, "not a valid amount of seconds"} | errors]}
    end
  end

  defp change_reserve_timer({config, errors}, reserve_timer) do
    if not is_integer(reserve_timer) or reserve_timer < 0 do
      {config, [{:reserve_timer, "not a valid amount of seconds"} | errors]}
    end
  end
end
