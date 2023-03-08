defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

  embed_templates "icons/*"

  attr :spinning, :boolean, default: false
  def moon_icon(assigns)

  attr :points, :integer, required: true
  def star_icon(assigns)

  attr :expiration, :integer, default: 24
  slot :legal
  slot :inner_block, required: true

  def promo(assigns) do
    assigns = assign(assigns, :minutes, assigns.expiration * 60)

    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in <%= @expiration %> hours
        (<%= @minutes %> minutes)
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def badge(assigns) do
    ~H"""
    <span class={["inline-flex items-center gap-0.5 rounded-full
             bg-gray-300 px-3 py-0.5 text-sm font-medium
             text-gray-800 hover:cursor-pointer", @class]} {@rest}>
      <%= @label %>
      <Heroicons.x_mark class="h-3 w-3 text-gray-600" />
    </span>
    """
  end

  attr :visible, :boolean, default: false

  def loading_indicator(assigns) do
    ~H"""
    <div :if={@visible} class="flex justify-center my-10 relative">
      <div class="w-12 h-12 rounded-full absolute border-8 border-gray-300">
      </div>
      <div class="w-12 h-12 rounded-full absolute border-8 border-indigo-400 border-t-transparent animate-spin">
      </div>
    </div>
    """
  end
end
