defmodule Captainsmode.DraftsFixture do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Captainsmode.Drafts` context.
  """
  alias Captainsmode.DraftState

  def unique_code, do: Captainsmode.StringHelper.generate_random_hex(6)

  def draft_fixture() do
    %DraftState{
      id: unique_code(),
      participants: [],
      status: :pending,
      pick_timer: 35,
      ban_timer: 35,
      banned: [],
      picked: []
    }
  end

  def full_draft_fixture() do
    %DraftState{
      id: unique_code(),
      participants: ["john", "jane"],
      status: :pending,
      pick_timer: 35,
      ban_timer: 35,
      banned: [],
      picked: []
    }
  end
end
