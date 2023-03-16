defmodule LiveViewStudioWeb.ServerFormComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.Servers
  alias LiveViewStudio.Servers.Server

  def mount(socket) do
    changeset = to_form(Servers.change_server(%Server{}))
    {:ok, assign(socket, :form, changeset)}
  end

  def handle_event("save", %{"server" => server_params}, socket) do
    case Servers.create_server(server_params) do
      {:error, changeset} ->
        IO.inspect(changeset)
        socket = put_flash(socket, :error, "WTF, dude?!")
        {:noreply, assign(socket, :form, to_form(changeset))}
      {:ok, server} ->
        send(self(), {:server_added, server})
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"server" => server_params}, socket) do
    changeset =
      %Server{}
      |> Servers.change_server(server_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
        <div class="field"><.input field={@form[:name]} placeholder="Name" autocomplete="off" /></div>
        <div class="field"><.input field={@form[:framework]} placeholder="Framework"/></div>
        <div class="field"><.input field={@form[:size]} type="number" placeholder="Size (MB)" /></div>
        <.button phx-disable-with="Saving...">Add server</.button>
        <.link patch={~p"/servers"} class="cancel">Cancel</.link>
      </.form>
    </div>
    """
  end
end
