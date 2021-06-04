defmodule Captainsmode.DraftServer do
  use GenServer, restart: :transient

  alias Captainsmode.{Drafts, DraftState}

  def start_link(draft_id) do
    GenServer.start_link(
      __MODULE__,
      draft_id,
      name: via(draft_id)
    )
  end

  @doc """
  Add a player to the drafting session.
  """
  @spec join(String.t(), String.t()) :: term()
  def join(draft_id, player_name) do
    GenServer.call(via(draft_id), {:join, player_name})
  end

  def handle_call({:join, player_name}, _from, state) do

  end

  @impl true
  def init(draft_id) do
    {:ok, %DraftState{id: draft_id}}
  end

  defp via(draft_id) do
    {:via, Registry, {:draft_registry, draft_id}}
  end
end
