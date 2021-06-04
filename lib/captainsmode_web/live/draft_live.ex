defmodule CaptainsmodeWeb.DraftLive do
  use CaptainsmodeWeb, :live_view

  alias Captainsmode.DraftServer
  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, CaptainsmodeWeb.NavComponentLive, id: :nav, username: assigns.username %>
    """
  end

  @impl true
  def mount(%{"draft_id" => draft_id}, _session, socket) do
    username = get_connect_params(socket)["user_data"]["username"]
    {:ok, assign(socket, %{username: username})}
  end
end
