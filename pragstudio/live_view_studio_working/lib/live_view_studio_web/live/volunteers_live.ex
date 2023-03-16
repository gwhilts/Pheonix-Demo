defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Volunteers
  alias LiveViewStudioWeb.VolunteerFormComponent

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()
    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:count, length(volunteers))
    {:ok, socket}
  end

  def handle_event("delete-volunteer", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)
    {:ok, volunteer} = Volunteers.delete_volunteer(volunteer)
    socket =
      socket
      |> stream_delete(:volunteers, volunteer)
      |> update(:count, & &1 - 1)
    {:noreply, socket}
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)
    {:ok, volunteer} = Volunteers.update_volunteer(volunteer, %{checked_out: !volunteer.checked_out})
    {:noreply, stream_insert(socket, :volunteers, volunteer)}
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket =
      socket
      |> stream_insert(:volunteers, volunteer, at: 0)
      |> update(:count, & &1 + 1)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Volunteer Check-In</h1>
    <div id="volunteer-checkin">
      <.live_component module={VolunteerFormComponent} id={:new} count={@count} />
      <div id="volunteers" phx-update="stream">
        <.volunteer
          :for={{volunteer_id, volunteer} <- @streams.volunteers}
          volunteer={volunteer}
          id={volunteer_id}
        />
      </div>
    </div>
    """
  end

  def volunteer(assigns) do
    ~H"""
      <div class={"volunteer #{if @volunteer.checked_out, do: "out"}"} id={@id}>
        <div class="name">
          <%= @volunteer.name %>
        </div>
        <div class="phone">
          <%= @volunteer.phone %>
        </div>
        <div class="status">
          <button phx-click={"toggle-status"} phx-value-id={@volunteer.id}>
            <%= if @volunteer.checked_out, do: "Check In", else: "Check Out" %>
          </button>
          <.link class="delete" phx-click="delete-volunteer" phx-value-id={@volunteer.id}>
            <.icon name="hero-trash-solid" />
          </.link>
        </div>
      </div>
    """
  end
end
