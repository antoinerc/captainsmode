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

  @doc """
  Allow a player to change side
  """
  @spec change_side(String.t(), String.t(), atom()) :: term()
  def change_side(draft_id, player_name, side) do
    GenServer.call(via(draft_id), {:change_side, player_name, side})
  end

  def pick_hero(draft_id, hero_id) do
    GenServer.call(via(draft_id), {:pick_hero, hero_id})
  end

  @impl true
  def handle_call({:join, player_name}, _from, state) do
    with {:ok, new_state} <- Drafts.join(state, player_name) do
      {:reply, {:ok, new_state}, new_state}
    else
      {:error, {code, state}} ->
        {:reply, {:error, code, state}, state}
    end
  end

  @impl true
  def handle_call({:change_side, player_name, side}, _from, state) do
    with {:ok, new_state} <- Drafts.change_side(state, player_name, side) do
      {:reply, {:ok, new_state}, new_state}
    else
      {:error, {code, state}} ->
        {:reply, {:error, code, state}, state}
    end
  end

  @impl true
  def handle_call({:pick_hero, hero_id}, _from, state) do
    with {:ok, new_state} <- Drafts.pick_hero(state, hero_id) do
      {:reply, {:ok, new_state}, new_state}
    else
      {:error, {code, state}} ->
        {:reply, {:error, code, state}, state}
    end
  end

  @impl true
  def init(draft_id) do
    {:ok, %DraftState{id: draft_id}}
  end

  defp via(draft_id) do
    {:via, Registry, {:draft_registry, draft_id}}
  end
end
