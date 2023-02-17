defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        query: "",
        vehicles: [],
        loading: false,
        matches: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="search" phx-change="suggest">
        <input
          type="text"
          name="query"
          value={@query}
          placeholder="Make or model"
          autofocus
          autocomplete="off"
          readonly={@loading}
          list="matches"
          phx-debounce="1000"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value={match}>
            <%= match %>
          </option>
        <% end %>
      </datalist>

      <div :if={@loading} class="loader">Loading...</div>

      <div class="vehicles">
        <ul>
          <li :for={vehicle <- @vehicles}>
            <span class="make-model">
              <%= vehicle.make_model %>
            </span>
            <span class="color">
              <%= vehicle.color %>
            </span>
            <span class={"status #{vehicle.status}"}>
              <%= vehicle.status %>
            </span>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:run_search, query})

    socket =
      assign(socket,
        query: query,
        vehicles: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    {:noreply,
     assign(
       socket,
       matches: Vehicles.suggest(query)
     )}
  end

  def handle_info({:run_search, query}, socket) do
    socket =
      assign(socket,
        vehicles: Vehicles.search(query),
        loading: false
      )

    {:noreply, socket}
  end
end
