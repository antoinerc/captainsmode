defmodule Captainsmode.DraftsTest do
  use Captainsmode.DataCase

  alias Captainsmode.Drafts
  alias Captainsmode.DraftsFixture

  @valid_draft_attrs_default %{
    side: "radiant",
    timer_type: "default"
  }

  @valid_draft_attrs_custom %{
    side: "dire",
    timer_type: "custom",
    pick_timer: 30,
    ban_timer: 30,
    reserve_timer: 0
  }

  @invalid_draft_attrs_default %{
    side: "bongo",
    timer_type: "bango"
  }

  @invalid_draft_attrs_custom %{
    side: "random",
    timer_type: "custom",
    pick_timer: -1,
    ban_timer: -1,
    reserve_timer: -1
  }

  describe "drafts" do
    test "configuration_changeset/1 returns no error when called with valid default configuration" do
      changeset = Drafts.change_configuration(%{}, @valid_draft_attrs_default)
      assert changeset.valid?
    end

    test "configuration_changeset/1 returns no error when called with valid custom configuration" do
      changeset = Drafts.change_configuration(%{}, @valid_draft_attrs_custom)
      assert changeset.valid?
    end

    test "configuration_changeset/1 returns errors when called with invalid default configuration" do
      changeset = Drafts.change_configuration(%{}, @invalid_draft_attrs_default)
      assert %{timer_type: ["is invalid"]} = errors_on(changeset)
    end

    test "configuration_changeset/1 returns errors when called with invalid custom configuration" do
      changeset = Drafts.change_configuration(%{}, @invalid_draft_attrs_custom)

      assert %{
               ban_timer: ["must be greater than or equal to 0"],
               pick_timer: ["must be greater than or equal to 0"],
               reserve_timer: ["must be greater than or equal to 0"]
             } = errors_on(changeset)
    end

    test "join_game/2 add the player to the participant list if not full and not already in" do
      username = "john"
      empty_state = DraftsFixture.draft_fixture()
      {:ok, new_state} = Drafts.join(empty_state, username)
      assert Enum.member?(new_state.participants, username)
    end

    test "join_game/2 returns an error if the player already joined" do
      username = "john"
      empty_state = DraftsFixture.draft_fixture()
      {:ok, new_state} = Drafts.join(empty_state, username)
      assert {:error, {:alread_joined, _}} = Drafts.join(new_state, username)
    end

    test "join_game/2 returns an error if the session is full" do
      username = "bobby"
      full_draft_state = DraftsFixture.full_draft_fixture()
      assert {:error, {:session_full, _}} = Drafts.join(full_draft_state, username)
    end
  end
end
