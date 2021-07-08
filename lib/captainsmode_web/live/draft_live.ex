defmodule CaptainsmodeWeb.DraftLive do
  use CaptainsmodeWeb, :live_view

  alias Captainsmode.DraftServer
  alias Captainsmode.DraftState

  @impl true
  def render(assigns) do
    ~L"""
    <%= if not all_sides_filled?(assigns.draft) do %>
    <h1 class="text-2xl font-semibold text-white instructions mt-2 text-center">
      Pick your side
    </h1>
    <% end %>
    <div class="grid grid-flow-col grid-rows-2 grid-cols-2 mt-2 justify-items-center">
        <label class="text-xl font-semibold">
          <span class="text-white">Radiant</span>
          <%= if not all_sides_filled?(assigns.draft) do %>
          <input class="form-radio text-green-600" type="radio" name="radiant" phx-click="change_side" value="radiant" <%= get_side_attributes(assigns, :radiant) %>>
          <% end %>
        </label>
        <p class="text-white italic"><%= assigns.draft.participants_sides.radiant %></p>
        <label class="text-xl font-semibold">
          <%= if not all_sides_filled?(assigns.draft) do %>
          <input class="form-radio text-red-600" type="radio" name="dire" phx-click="change_side" value="dire" <%= get_side_attributes(assigns, :dire) %>>
          <% end %>
          <span class="text-white">Dire</span>
        </label>
        <p class="text-white italic"><%= assigns.draft.participants_sides.dire %></p>
    </div>
    <div class="grid grid-cols-2 mt-1 justify-items-center">
      <%= if all_sides_filled?(assigns.draft) do %>
      <div class="grid grid-cols-1 gap-2">
      <%= for phase when phase.side == :radiant <- assigns.draft.phases do %>
        <div class="ring-4 <%= if phase.order == assigns.draft.current_phase, do: 'ring-opacity-100', else: 'ring-opacity-50' %> <%= get_ring_color(phase.type) %>"><%= phase.side %>-<%= phase.type %></div>
      <% end %>
      </div>
      <div class="grid grid-cols-1 gap-2">
      <%= for phase when phase.side == :dire <- assigns.draft.phases do %>
        <div class="ring-4 <%= if phase.order == assigns.draft.current_phase, do: 'ring-opacity-100', else: 'ring-opacity-50' %> <%= get_ring_color(phase.type) %>"><%= phase.side %>-<%= phase.type %></div>
      <% end %>
      </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(%{"draft_id" => draft_id}, _session, socket) do
    username = get_connect_params(socket)["user_data"]["username"]

    case connected?(socket) do
      true -> connected_mount(draft_id, socket)
      false -> {:ok, assign(socket, %{username: username, draft: %DraftState{id: draft_id}})}
    end
  end

  def connected_mount(draft_id, socket) do
    username = get_connect_params(socket)["user_data"]["username"]
    {:ok, draft_state} = DraftServer.join(draft_id, username)
    {:ok, assign(socket, %{username: username, draft: draft_state})}
  end

  @impl true
  def handle_event("change_side", %{"value" => side}, socket) do
    case DraftServer.change_side(socket.assigns.draft.id, socket.assigns.username, side) do
      {:ok, draft_state} ->
        {:noreply, assign(socket, %{draft: draft_state})}

      {:error, :side_full, draft_state} ->
        socket = put_flash(socket, :error, "#{String.capitalize(side)} has already been picked")
        {:noreply, assign(socket, %{draft: draft_state})}
    end
  end

  def get_side_attributes(assigns, side) do
    username = assigns.username

    case Map.fetch(assigns.draft.participants_sides, side) do
      {:ok, ^username} ->
        "checked disabled"

      {:ok, nil} ->
        ""

      _ ->
        "disabled"
    end
  end

  def get_ring_color(side) do
    case side do
      :pick -> "ring-green-500"
      :ban -> "ring-red-500"
    end
  end

  def all_sides_filled?(draft) do
    case draft.participants_sides do
      %{dire: nil, radiant: _} -> false
      %{dire: _, radiant: nil} -> false
      _ -> true
    end
  end
end
