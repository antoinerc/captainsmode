defmodule Captainsmode.DraftsTest do
  use Captainsmode.DataCase

  alias Captainsmode.Drafts

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
      changeset = Drafts.configuration_changeset(@valid_draft_attrs_default)
      assert changeset.valid?
    end

    test "configuration_changeset/1 returns no error when called with valid custom configuration" do
      changeset = Drafts.configuration_changeset(@valid_draft_attrs_custom)
      assert changeset.valid?
    end

    test "configuration_changeset/1 returns errors when called with invalid default configuration" do
      changeset = Drafts.configuration_changeset(@invalid_draft_attrs_default)
      assert %{timer_type: ["is invalid"], side: ["is invalid"]} = errors_on(changeset)
    end

    test "configuration_changeset/1 returns errors when called with invalid custom configuration" do
      changeset = Drafts.configuration_changeset(@invalid_draft_attrs_custom)

      assert %{
               ban_timer: ["must be greater than or equal to 0"],
               pick_timer: ["must be greater than or equal to 0"],
               reserve_timer: ["must be greater than or equal to 0"]
             } = errors_on(changeset)
    end
  end
end
