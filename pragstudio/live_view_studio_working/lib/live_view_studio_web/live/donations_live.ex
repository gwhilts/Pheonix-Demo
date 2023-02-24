defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def handle_params(params, _uri, socket) do
    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    options = %{
      sort_by: sort_by,
      sort_order: sort_order
    }

    socket = assign(socket,
     donations: Donations.list_donations(options),
     options: options
    )

    {:noreply, socket}
  end

  attr :options, :map, required: true
  attr :sort_by, :atom, required: true
  slot :inner_block, required: true
  def sort_link(assigns) do
    ~H"""
    <.link patch={~p"/donations?#{%{sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"}>
      <%= render_slot(@inner_block) %><span><%= sort_indicator(@sort_by, @options) %></span>
    </.link>
    """
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  defp sort_indicator(col, %{sort_by: sort_by, sort_order: sort_order}) when col == sort_by do
    IO.inspect({col, sort_by}, label: "sort_indicator args:")
    case sort_order do
      :asc -> " ↑"
      :desc -> " ↓"
    end
  end

  defp sort_indicator(_, _), do: ""
end
