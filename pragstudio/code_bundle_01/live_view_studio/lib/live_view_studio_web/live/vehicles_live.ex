defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        vehicles: [],
        loading: false,
        foo: %{}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="find_vehicle" phx-change="suggest">
        <input
          type="text"
          name="query"
          value=""
          placeholder="Make or model"
          autofocus
          autocomplete="off"
          list="matches"
        />

        <button>
          <img src="/images/search.svg" />
        </button>

        <datalist id="matches">
          <option :for={vehicle <- @foo} value={vehicle} name={vehicle}>
          </option>
        </datalist>
      </form>

      <div :if={@loading} class="loader"></div>

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

  def handle_event("find_vehicle", %{"query" => query}, socket) do
    send(self(), {:run_search, query})
    {:noreply, assign(socket, loading: true, vehicles: [])}
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    {:noreply, assign(socket, foo: Vehicles.suggest(query))}
  end

  def handle_info({:run_search, query}, socket) do
    {:noreply, assign(socket, loading: false, vehicles: Vehicles.search(query))}
  end
end
