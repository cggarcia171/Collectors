defmodule RumblWeb.CollectionControllerTest do
  use RumblWeb.ConnCase

  alias Rumbl.Collected

  @create_attrs %{title: "some title", type: "some type"}
  @update_attrs %{title: "some updated title", type: "some updated type"}
  @invalid_attrs %{title: nil, type: nil}

  def fixture(:collection) do
    {:ok, collection} = Collected.create_collection(@create_attrs)
    collection
  end

  describe "index" do
    test "lists all collections", %{conn: conn} do
      conn = get(conn, Routes.collection_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Collections"
    end
  end

  describe "new collection" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.collection_path(conn, :new))
      assert html_response(conn, 200) =~ "New Collection"
    end
  end

  describe "create collection" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.collection_path(conn, :create), collection: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.collection_path(conn, :show, id)

      conn = get(conn, Routes.collection_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Collection"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.collection_path(conn, :create), collection: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Collection"
    end
  end

  describe "edit collection" do
    setup [:create_collection]

    test "renders form for editing chosen collection", %{conn: conn, collection: collection} do
      conn = get(conn, Routes.collection_path(conn, :edit, collection))
      assert html_response(conn, 200) =~ "Edit Collection"
    end
  end

  describe "update collection" do
    setup [:create_collection]

    test "redirects when data is valid", %{conn: conn, collection: collection} do
      conn = put(conn, Routes.collection_path(conn, :update, collection), collection: @update_attrs)
      assert redirected_to(conn) == Routes.collection_path(conn, :show, collection)

      conn = get(conn, Routes.collection_path(conn, :show, collection))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, collection: collection} do
      conn = put(conn, Routes.collection_path(conn, :update, collection), collection: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Collection"
    end
  end

  describe "delete collection" do
    setup [:create_collection]

    test "deletes chosen collection", %{conn: conn, collection: collection} do
      conn = delete(conn, Routes.collection_path(conn, :delete, collection))
      assert redirected_to(conn) == Routes.collection_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.collection_path(conn, :show, collection))
      end
    end
  end

  defp create_collection(_) do
    collection = fixture(:collection)
    {:ok, collection: collection}
  end
end
