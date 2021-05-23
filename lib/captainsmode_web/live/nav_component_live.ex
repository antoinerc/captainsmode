defmodule CaptainsmodeWeb.NavComponentLive do
  use CaptainsmodeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, %{})}
  end
end
