defmodule SquawkWeb.PostsLive.FormComponent do
  use SquawkWeb, :live_component

  alias Squawk.TimeLine

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>You got something to say, jack?!</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="posts-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :body}} type="textarea" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Posts</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{posts: posts} = assigns, socket) do
    changeset = TimeLine.change_posts(posts)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"posts" => posts_params}, socket) do
    changeset =
      socket.assigns.posts
      |> TimeLine.change_posts(posts_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"posts" => posts_params}, socket) do
    save_posts(socket, socket.assigns.action, posts_params)
  end

  defp save_posts(socket, :edit, posts_params) do
    case TimeLine.update_posts(socket.assigns.posts, posts_params) do
      {:ok, _posts} ->
        {:noreply,
         socket
         |> put_flash(:info, "Posts updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_posts(socket, :new, posts_params) do
    case TimeLine.create_posts(posts_params) do
      {:ok, _posts} ->
        {:noreply,
         socket
         |> put_flash(:info, "Posts created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
