defmodule Captainsmode.GameSupervisor do
  @moduledoc """
  Manage the state of the game servers
  """
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_child(child) do
    DynamicSupervisor.start_child(__MODULE__, child)
  end

  def terminate_child(child_pid) do
    with [{child_pid, _}] <- Registry.lookup(:game_registry, child_pid) do
      DynamicSupervisor.terminate_child(__MODULE__, child_pid)
    end
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
