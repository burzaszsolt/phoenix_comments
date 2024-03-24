defmodule PhoenixCommentsWeb.CommentsChannel do
  use PhoenixCommentsWeb, :channel
  alias PhoenixComments.Comment
  alias PhoenixComments.Repo

  @impl true
  def join("comments:list", _params, socket) do

    comments = Comment
    |> Repo.all()
    |> Repo.preload(:user)

    {:ok, %{comments: comments}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comments:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
