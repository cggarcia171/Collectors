defmodule RumblWeb.CollectionController do
  use RumblWeb, :controller

  alias Rumbl.Collected
  alias Rumbl.Collected.Collection

  def index(conn, _params, current_user) do
    collections = Collected.list_user_collections(current_user)
    render(conn, "index.html", collections: collections)
  end

  def new(conn, _params, current_user) do
    changeset = Collected.change_collection(current_user, %Collection{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"collection" => collection_params}, current_user) do
    case Collected.create_collection(current_user, collection_params) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "It worked, Good job!")
        |> redirect(to: Routes.collection_path(conn, :show, collection))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    collection = Collected.get_user_collection!(current_user, id)
    render(conn, "show.html", collection: collection)
  end

  def edit(conn, %{"id" => id}, current_user) do
    collection = Collected.get_user_collection!(current_user, id)
    changeset = Collected.change_collection(current_user, collection)
    render(conn, "edit.html", collection: collection, changeset: changeset)
  end

  def update(conn, %{"id" => id, "collection" => collection_params}, current_user) do
    collection = Collected.get_user_collection!(current_user, id)

    case Collected.update_collection(collection, collection_params) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "Collection updated successfully.")
        |> redirect(to: Routes.collection_path(conn, :show, collection))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", collection: collection, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    collection = Collected.get_collection!(current_user, id)
    {:ok, _collection} = Collected.delete_collection(collection)

    conn
    |> put_flash(:info, "Collection deleted successfully.")
    |> redirect(to: Routes.collection_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
