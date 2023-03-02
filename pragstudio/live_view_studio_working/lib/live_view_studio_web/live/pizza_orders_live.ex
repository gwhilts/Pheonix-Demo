defmodule LiveViewStudioWeb.PizzaOrdersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.PizzaOrders
  import Number.Currency

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [pizza_orders: []]}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    {:noreply, push_patch(socket, to: ~p"/pizza-orders?#{%{socket.assigns.options | per_page: per_page}}")}
  end

  def handle_params(params, _uri, socket) do
    sort_by = valid_sort_by(params)
    sort_order = valid_sort_order(params)

    options = %{
      sort_by: sort_by,
      sort_order: sort_order,
      page: param_to_int(params["page"], 1),
      per_page: param_to_int(params["per_page"], 5),
      total_count: PizzaOrders.count()
    }

    socket = assign(socket,
     pizza_orders: PizzaOrders.list_pizza_orders(options),
     options: options
    )

    {:noreply, socket}
  end

  defp more_pages?(options, total_count) do
    options.page * options.per_page < total_count
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      _ -> :asc
    end
  end

  defp param_to_int(nil, default), do: default
  defp param_to_int(param, default) do
    case Integer.parse(param) do
      :error -> default
      {int, _} -> int
    end
  end

  defp sort_indicator(col, %{sort_by: sort_by, sort_order: sort_order}) when col == sort_by do
    IO.inspect({col, sort_by}, label: "sort_indicator args:")
    case sort_order do
      :asc -> " ↑"
      :desc -> " ↓"
    end
  end

  defp sort_indicator(_, _), do: raw("&nbsp;&nbsp;")

  attr :options, :map, required: true
  attr :sort_by, :atom, required: true
  slot :inner_block, required: true
  defp sort_link(assigns) do
    ~H"""
    <.link patch={~p"/pizza-orders?#{%{@options | sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"}>
      <%= render_slot(@inner_block) %><span><%= sort_indicator(@sort_by, @options) %></span>
    </.link>
    """
  end


  defp valid_sort_by(%{"sort_by" => sort_by}) when sort_by in ~w{price size style topping_1 topping_2} do
    String.to_atom(sort_by)
  end

  defp valid_sort_by(_params), do: :id

  defp valid_sort_order(%{"sort_order" => sort_order}) when sort_order in ~w{asc desc} do
    String.to_atom(sort_order)
  end

  defp valid_sort_order(_params), do: :asc

end
