defmodule PhoenixCommentsWeb.PageController do
  use PhoenixCommentsWeb, :controller

  alias PhoenixComments.Comment
  alias PhoenixComments.Repo

  def home(conn, _params) do
    changeset = Comment.changeset(%Comment{})
    render(conn, :home, changeset: changeset)
  end

  def create(conn, %{"comment" => comment}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:comments)
      |> Comment.changeset(comment)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/")
      {:error, changeset} -> render(conn, :home, changeset: changeset)
    end
  end
end
