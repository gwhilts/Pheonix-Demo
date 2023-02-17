defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 10, temp: "3000")}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temp)}"}><%=@brightness %>%</span>
      </div>
      <form phx-change="dim">
        <input type="range" min="0" max="100" name="brightness" value={@brightness} phx-debounce="250" />
      </form>
      <br/>
      <form phx-change="update_temp">
        <div class="temps">
          <%= for temp <- ["3000", "4000", "5000"] do %>
            <input type="radio" id={temp} name="temp" value={temp} checked={temp == @temp}/>
            <label for={temp}><%= temp %>°</label>
          <% end %>
        </div>
      </form>
      <br/>
      <button phx-click="off"><img src="/images/light-off.svg"/></button>
      <button phx-click="down"><img src="/images/down.svg"/></button>
      <button phx-click="up"><img src="/images/up.svg"/></button>
      <button phx-click="on"><img src="/images/light-on.svg"/></button>
      <button phx-click="random"><img src="/images/fire.svg"/></button>
    </div>
    """
  end

  def handle_event("on", _, socket) do
      {:noreply, assign(socket, brightness: 100)}
  end

  def handle_event("off", _, socket) do
      {:noreply, assign(socket, brightness: 0)}
  end

  def handle_event("down", _, socket) do
    {:noreply, update(socket, :brightness, &(max 0, &1 - 10))}
  end

  def handle_event("up", _, socket) do
    {:noreply, update(socket, :brightness, &(min &1 + 10, 100))}
  end

  def handle_event("random", _, socket) do
    {:noreply, assign(socket, brightness: Enum.random(0..100))}
  end

  def handle_event("dim", %{"brightness" => b}, socket) do
    {:noreply, assign(socket, brightness: b)}
  end

  def handle_event("update_temp", %{"temp" => temp}, socket) do
    {:noreply, assign(socket, temp: temp)}
  end


  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#F3FF66"
  defp temp_color("5000"), do: "#99CCFF"
end
