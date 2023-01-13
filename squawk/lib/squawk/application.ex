defmodule Squawk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SquawkWeb.Telemetry,
      # Start the Ecto repository
      Squawk.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Squawk.PubSub},
      # Start Finch
      {Finch, name: Squawk.Finch},
      # Start the Endpoint (http/https)
      SquawkWeb.Endpoint
      # Start a worker by calling: Squawk.Worker.start_link(arg)
      # {Squawk.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Squawk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SquawkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
