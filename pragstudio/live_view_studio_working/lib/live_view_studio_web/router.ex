defmodule LiveViewStudioWeb.Router do
  use LiveViewStudioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveViewStudioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveViewStudioWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/athletes", AthletesLive
    live "/bingo", BingoLive
    live "/boats", BoatsLive
    live "/bookings", BookingsLive
    live "/desks", DesksLive
    live "/donations", DonationsLive
    live "/flights", FlightsLive
    live "/juggling", JugglingLive
    live "/light", LightLive
    live "/pizza-orders", PizzaOrdersLive
    live "/presence", PresenceLive
    live "/sales", SalesLive
    live "/sandbox", SandboxLive
    live "/servers", ServersLive
    live "/servers/new", ServersLive, :new
    live "/servers/id", ServersLive
    live "/shop", ShopLive
    live "/topsecret", TopSecretLive
    live "/vehicles", VehiclesLive
    live "/volunteers", VolunteersLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveViewStudioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_view_studio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveViewStudioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
