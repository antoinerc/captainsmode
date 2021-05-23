defmodule CaptainsmodeWeb.ModalComponent do
  use CaptainsmodeWeb, :live_component

  @impl true
  def handle_event("close", _params, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
