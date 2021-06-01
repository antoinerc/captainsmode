defmodule CaptainsmodeWeb.NavComponentLive do
  use CaptainsmodeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <nav class="bg-gray-900 p-4 mt-0 w-full">
      <div class="container mx-auto flex items-center mt-0">
        <div class="w-1/3">
          <div class="flex text-white font-extrabold">
            <a class="flex text-white text-2xl no-underline" href="#">Captain's Mode</a>
          </div>
        </div>
        <div class="w-1/3 text-center text-white">
          <%= @username %>
        </div>
        <div class="w-1/3">
          <%= live_patch to: Routes.home_path(@socket, :new_draft), class: "float-right btn-indigo" do %>
            <%= gettext "Start a new draft" %>
          <% end %>
        </div>
      </div>
    </nav>
    """
  end
end
