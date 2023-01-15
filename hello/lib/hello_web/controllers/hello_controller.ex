defmodule HelloWeb.HelloController do
  use HelloWeb, :controller
  def index(conn, %{"messenger" => messenger}) do
    render(conn, :index, messenger: messenger)
  end

  def index(conn, _params) do
    render(conn, messenger: "Phoenix")
  end
end
