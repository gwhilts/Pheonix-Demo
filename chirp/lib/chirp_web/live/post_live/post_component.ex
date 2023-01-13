defmodule ChirpWeb.PostLive.PostComponent do
  use ChirpWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"post-#{@post.id}"} class="post border-solid border-2 border-sky-500 p-4 m-8">
      <div class="avatar w-16 h-18 border-solid border-1 border-slate-700 float-left">
        <Heroicons.user class="w-12 h-18 stroke-current inline"/>
      </div>
      <div class="p-1 pl-20 font-bold">@<%= @post.username %></div>
      <div class="p-1 pl-20"><%= @post.body %></div>
      <div class="actions text-center">
        <.link href="#" class="pl-3 pr-3" phx-click="like" phx-target={@myself}>
          <Heroicons.heart class="w-4 h-4 stroke-current inline" /> <%= @post.likes_count %>
        </.link>
        <.link href="#" class="pl-3 pr-3" phx-click="repost" phx-target={@myself}>
          <Heroicons.arrow_path_rounded_square class="w-4 h-4 stroke-current inline" /> <%= @post.repost_count %>
        </.link>
        <.link patch={~p"/posts/#{@post.id}/edit"} class="pl-3 pr-3">
          <Heroicons.pencil_square class="w-4 h-4 stroke-current inline" />
        </.link>
        <.link class="pl-3 pr-3" phx-click={JS.push("delete", value: %{id: @post.id})} data-confirm="Are you sure?">
          <Heroicons.trash class="w-4 h-4 stroke-current inline" />
        </.link>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    Chirp.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    Chirp.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
