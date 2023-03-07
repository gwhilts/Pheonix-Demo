defmodule EbnoBetaWeb.CustomComponents do
  @moduledoc """
  Additional UI components.
  """
  use Phoenix.Component

  # alias Phoenix.LiveView.JS
  # import EbnoBetaWeb.Gettext

  attr :href, :string, required: true
  slot :inner_block, required: true
  def mobile_nav_item(assigns) do
    ~H"""
    <li class="py-8" onclick="document.getElementById('mobile_nav_menu').classList.toggle('hidden')">
      <a href={@href}><%= render_slot @inner_block %></a>
    </li>
    """
  end

end
