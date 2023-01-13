defmodule SquawkWeb.PostsLive.Index do
  use SquawkWeb, :live_view

  alias Squawk.TimeLine
  alias Squawk.TimeLine.Posts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :posts_collection, list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Squawk")
    |> assign(:posts, TimeLine.get_posts!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Squawk")
    |> assign(:posts, %Posts{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Timeline")
    |> assign(:posts, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    posts = TimeLine.get_posts!(id)
    {:ok, _} = TimeLine.delete_posts(posts)

    {:noreply, assign(socket, :posts_collection, list_posts())}
  end

  defp list_posts do
    TimeLine.list_posts()
  end
end
