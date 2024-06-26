defmodule PhoenixCommentsWeb.AuthController do
  use PhoenixCommentsWeb, :controller
  plug Ueberauth

  alias PhoenixComments.User
  alias PhoenixComments.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      url: auth.info.urls.html_url,
      name: auth.info.name || auth.info.nickname,
      profile_image: auth.info.image,
      provider: "github"
    }
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back #{user.name}!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, url: changeset.changes.url) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
