defmodule Rumbl.Collected do
  @moduledoc """
  The Collected context.
  """

  import Ecto.Query, warn: false
  alias Rumbl.Repo
  alias Rumbl.Accounts
  alias Rumbl.Collected.Collection

  def list_collections do
    Collection
    |> Repo.all()
    |> preload_user()
  end
  def list_user_collections(%Accounts.User{} = user) do
    Collection
    |> user_collections_query(user)
    |> Repo.all()
    |> preload_user()
  end

  def get_collection!(id), do: preload_user(Repo.get!(Collection, id))
  def get_user_collection!(%Accounts.User{} = user, id) do
    from(c in Collection, where: c.id == ^id)
    |> user_collections_query(user)
    |> Repo.one!()
    |> preload_user()
  end

  def create_collection(%Accounts.User{} = user, attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  def change_collection(%Accounts.User{} = user, %Collection{} = collection) do
    collection
    |> Collection.changeset(%{})
    |> put_user(user)
  end

  
  defp preload_user(collection_or_collections)do
    Repo.preload(collection_or_collections, :user)
  end
  defp put_user(changeset, user) do 
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end
  defp user_collections_query(query, %Accounts.User{id: user_id}) do
    from(c in query, where: c.user_id == ^user_id)
  end
end
