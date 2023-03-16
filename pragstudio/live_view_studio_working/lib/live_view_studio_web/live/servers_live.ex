defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers
  alias LiveViewStudio.Servers.Server

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()
    socket = assign(socket, servers: servers, coffees: 0)
    {:ok, socket}
  end

  def handle_event("drink", _, socket) do
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    {:ok, server} =
      Servers.get_server!(id)
      |> Servers.toggle_status()

    servers =
      Enum.map(socket.assigns.servers, fn svr ->
        if svr.id == server.id, do: server, else: svr
      end)

    {:noreply, assign(socket, selected_server: server, servers: servers)}
  end

  def handle_info({:server_added, server}, socket) do
   socket =
    update(socket, :servers, fn servers -> [server | servers] end)
    |> put_flash(:info, "Server added!")
    {:noreply, push_patch(socket, to: ~p"/servers")}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    server = Servers.get_server!(id)
    {:noreply, assign(socket, selected_server: server, page_title: server.name)}
  end

  def handle_params(_params, _url, socket) do
    IO.inspect(socket.assigns.servers, label: "***socket.assigns.servers: ")
    {:noreply, assign(socket, selected_server: hd(socket.assigns.servers))}
  end

  def render(assigns) do
    ~H"""
    <h1>Servers</h1>

    <div id="servers">
      <div class="sidebar">
        <div class="nav">
          <.link class="add" patch={~p"/servers/new"}>
            Add server ...
          </.link>
          <.link
            :for={server <- @servers}
            patch={~p"/servers?#{[id: server]}"}
            class={if server == @selected_server, do: "selected"}
          >
            <span class={server.status}></span>
            <%= server.name %>
          </.link>
        </div>
        <div class="coffees">
          <button phx-click="drink">
            <img src="/images/coffee.svg" />
            <%= @coffees %>
          </button>
        </div>
      </div>
      <div class="main">
        <div class="wrapper">
          <%= if @live_action == :new do %>
              <.live_component module={LiveViewStudioWeb.ServerFormComponent} id={:new} />
          <% else %>
            <.server server={@selected_server} />
          <% end %>
          <div class="links">
            <.link navigate={~p"/light"}>
              Adjust lights
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp server(assigns) do
    ~H"""
    <div class="server">
      <div class="header">
        <h2><%= @server.name %></h2>
        <button class={@server.status} phx-click="toggle-status" phx-value-id={@server.id}>
          <%= @server.status %>
        </button>
      </div>
      <div class="body">
        <div class="row">
          <span>
            <%= @server.deploy_count %> deploys
          </span>
          <span>
            <%= @server.size %> MB
          </span>
          <span>
            <%= @server.framework %>
          </span>
        </div>
        <h3>Last Commit Message:</h3>
        <blockquote>
          <%= @server.last_commit_message %>
        </blockquote>
      </div>
    </div>
    """
  end
end
