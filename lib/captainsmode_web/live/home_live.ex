defmodule CaptainsmodeWeb.HomeLive do
  use CaptainsmodeWeb, :live_view

  import CaptainsmodeWeb.Helpers

  @impl true
  def render(assigns) do
    ~L"""
    <%= if @live_action == :new_draft do %>
      <%= live_modal @socket, CaptainsmodeWeb.DraftFormComponent,
        id: :start_draft_modal,
        modal_class: "w-full max-w-md",
        return_to: Routes.home_path(@socket, :index) %>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end

  @impl true
  def handle_params(_params, _url, socket), do: {:noreply, socket}
end
