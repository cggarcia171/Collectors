defmodule Rumbl.Collected.Collection do
  use Ecto.Schema
  import Ecto.Changeset


  schema "collections" do
    field :title, :string
    field :type, :string
    belongs_to :user, Rumbl.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:title, :type])
    |> validate_required([:title, :type])
  end
end
