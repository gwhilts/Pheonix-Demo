defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def handle_params(params, _uri, socket) do
    options = %{
      page: param_to_int(params["page"], 1),
      per_page: param_to_int(params["per_page"], 5),
      sort_by: valid_sort_by(params),
      sort_order: valid_sort_order(params)
    }

    socket = assign(socket,
     donations: Donations.list_donations(options),
     options: options,
     total_count: Donations.count_donations()
    )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    {:noreply, push_patch(socket, to: ~p"/donations?#{%{socket.assigns.options | per_page: per_page}}")}
  end

  attr :options, :map, required: true
  attr :sort_by, :atom, required: true
  slot :inner_block, required: true

  def sort_link(assigns) do
    ~H"""
    <.link patch={~p"/donations?#{%{@options | sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"}>
      <%= render_slot(@inner_block) %><span><%= sort_indicator(@sort_by, @options) %></span>
    </.link>
    """
  end

  defp more_pages?(options, total_count) do
    options.page * options.per_page < total_count
  end

  def pages(options, total_count) do
    page_count = ceil(total_count / options.per_page)
    for page_number <- (options.page - 2)..(options.page + 2), page_number > 0 do
      if page_number <= page_count do
        current_page? = page_number == options.page
        {page_number, current_page?}
      end
    end
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
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
    case sort_order do
      :asc -> " ↑"
      :desc -> " ↓"
    end
  end
  defp sort_indicator(_, _), do: ""

  defp valid_sort_by(%{"sort_by" => sort_by}) when sort_by in ~w{item quantity days_until_expires} do
    String.to_atom(sort_by)
  end

  defp valid_sort_by(_params), do: :id

  defp valid_sort_order(%{"sort_order" => sort_order}) when sort_order in ~w{asc desc} do
    String.to_atom(sort_order)
  end

  defp valid_sort_order(_params), do: :asc

end
