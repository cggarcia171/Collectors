defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  alias Rumbl.Accounts.User
  alias Rumbl.Accounts
  alias RumblWeb.Auth
  plug :authenticate_user when action in [:index, :show]

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    # case authenticate(conn) do
    # %Plug.Conn{halted: true} = conn ->
     #  conn

      #      conn ->
        users = Accounts.list_users()
        render(conn, "index.html", users: users)
    #end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end
  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp authenticate(conn, opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to enter this page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
