defmodule Captainsmode.DraftServer do
  @moduledoc """
  GenServer implementation used to manipulate the `Captainsmode.DraftState`.
  """
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

  def pick_hero(draft_id, hero_id, username) do
    GenServer.call(via(draft_id), {:pick_hero, hero_id, username})
  end

  @impl true
  def handle_call({:join, player_name}, _from, state) do
    case Drafts.join(state, player_name) do
      {:ok, new_state} -> {:reply, {:ok, new_state}, new_state}
      {:error, {code, state}} -> {:reply, {:error, code, state}, state}
    end
  end

  @impl true
  def handle_call({:change_side, player_name, side}, _from, state) do
    case Drafts.change_side(state, player_name, side) do
      {:ok, new_state} ->
        {:reply, {:ok, new_state}, new_state}

      {:error, {code, state}} ->
        {:reply, {:error, code, state}, state}
    end
  end

  @impl true
  def handle_call({:pick_hero, hero_id, username}, _from, state) do
    case Drafts.pick_hero(state, hero_id, username) do
      {:ok, new_state} -> {:reply, {:ok, new_state}, new_state}
      {:error, {code, state}} -> {:reply, {:error, code, state}, state}
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
