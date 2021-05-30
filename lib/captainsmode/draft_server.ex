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

  @impl true
  def init(draft_id) do
    {:ok, %DraftState{id: draft_id}}
  end

  defp via(draft_id) do
    {:via, Registry, {:draft_registry, draft_id}}
  end
end
