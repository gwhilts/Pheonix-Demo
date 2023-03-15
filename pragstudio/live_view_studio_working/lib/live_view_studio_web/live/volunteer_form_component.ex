defmodule LiveViewStudioWeb.VolunteerFormComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})
    {:ok, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:error, changeset} -> {:noreply, assign(socket, :form, to_form(changeset))}
      {:ok, volunteer} ->
        send(self(), {:volunteer_created, volunteer})
        {:noreply, assign(socket, :form, to_form(Volunteers.change_volunteer(%Volunteer{})))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
        <.input field={@form[:name]} placeholder="Name" autocomplete="off" phx-debounce="2000"/>
        <.input field={@form[:phone]} type="tel" placeholder="Phone" autocomplete="off" phx-debounce="blur"/>
        <.button phx-disable-with="Saving...">Check In</.button>
      </.form>
    </div>
    """
  end
end
