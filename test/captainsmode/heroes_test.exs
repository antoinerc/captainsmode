defmodule Captainsmode.HeroesTest do
  use Captainsmode.DataCase

  alias Captainsmode.Heroes

  describe "heroes" do
    alias Captainsmode.Heroes.Hero

    @valid_attrs %{img: "some img", name: "some name", json_id: 123}
    @update_attrs %{img: "some updated img", name: "some updated name", json_id: 123}
    @invalid_attrs %{img: nil, name: nil, json_id: nil}

    def hero_fixture(attrs \\ %{}) do
      {:ok, hero} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Heroes.create_hero()

      hero
    end

    test "list_heroes/0 returns all heroes" do
      hero = hero_fixture()
      assert Heroes.list_heroes() == [hero]
    end

    test "get_hero!/1 returns the hero with given id" do
      hero = hero_fixture()
      assert Heroes.get_hero!(hero.id) == hero
    end

    test "create_hero/1 with valid data creates a hero" do
      assert {:ok, %Hero{} = hero} = Heroes.create_hero(@valid_attrs)
      assert hero.img == "some img"
      assert hero.name == "some name"
    end

    test "create_hero/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Heroes.create_hero(@invalid_attrs)
    end

    test "update_hero/2 with valid data updates the hero" do
      hero = hero_fixture()
      assert {:ok, %Hero{} = hero} = Heroes.update_hero(hero, @update_attrs)
      assert hero.img == "some updated img"
      assert hero.name == "some updated name"
    end

    test "update_hero/2 with invalid data returns error changeset" do
      hero = hero_fixture()
      assert {:error, %Ecto.Changeset{}} = Heroes.update_hero(hero, @invalid_attrs)
      assert hero == Heroes.get_hero!(hero.id)
    end

    test "delete_hero/1 deletes the hero" do
      hero = hero_fixture()
      assert {:ok, %Hero{}} = Heroes.delete_hero(hero)
      assert_raise Ecto.NoResultsError, fn -> Heroes.get_hero!(hero.id) end
    end

    test "change_hero/1 returns a hero changeset" do
      hero = hero_fixture()
      assert %Ecto.Changeset{} = Heroes.change_hero(hero)
    end
  end
end
