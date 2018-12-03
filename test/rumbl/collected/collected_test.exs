defmodule Rumbl.CollectedTest do
  use Rumbl.DataCase

  alias Rumbl.Collected

  describe "collections" do
    alias Rumbl.Collected.Collection

    @valid_attrs %{title: "some title", type: "some type"}
    @update_attrs %{title: "some updated title", type: "some updated type"}
    @invalid_attrs %{title: nil, type: nil}

    def collection_fixture(attrs \\ %{}) do
      {:ok, collection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Collected.create_collection()

      collection
    end

    test "list_collections/0 returns all collections" do
      collection = collection_fixture()
      assert Collected.list_collections() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Collected.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      assert {:ok, %Collection{} = collection} = Collected.create_collection(@valid_attrs)
      assert collection.title == "some title"
      assert collection.type == "some type"
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collected.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{} = collection} = Collected.update_collection(collection, @update_attrs)
      assert collection.title == "some updated title"
      assert collection.type == "some updated type"
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Collected.update_collection(collection, @invalid_attrs)
      assert collection == Collected.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Collected.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Collected.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Collected.change_collection(collection)
    end
  end
end
