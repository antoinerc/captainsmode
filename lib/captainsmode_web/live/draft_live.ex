defmodule CaptainsmodeWeb.DraftLive do
  use CaptainsmodeWeb, :live_view

  alias Captainsmode.DraftServer
  alias Captainsmode.DraftState
  alias Captainsmode.Heroes

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
    <%= if all_sides_filled?(assigns.draft) do %>
    <div class="grid p-3 gap-4 grid-cols-8 h-72 overflow-y-auto">
      <%= for hero <- assigns.heroes do %>
      <div class="ring-4 text-center h-12" phx-click="pick_hero" phx-value-hero=<%= hero.id %>>
        <%= hero.name %>
      </div>
      <% end %>
    </div>
    <div class="grid grid-flow-row grid-cols-<%= div(length(assigns.draft.phases), 2) %> grid-rows-2 gap-4">
      <%= for %{hero: hero, type: type, side: side} when side == :radiant <- assigns.draft.phases do %>
      <div class="h-12 w-12 mt-6 ring-4 <%= get_ring_color(type) %>">
        <%= hero %>
      </div>
      <% end %>
      <%= for %{hero: hero, type: type, side: side} when side == :dire <- assigns.draft.phases do %>
      <div class="h-12 w-12 mt-6 ring-4 <%= get_ring_color(type) %>">
        <%= hero %>
      </div>
      <% end %>
    <% end %>
    """
  end

  @impl true
  def mount(%{"draft_id" => draft_id}, _session, socket) do
    username = get_connect_params(socket)["user_data"]["username"]
    heroes = Heroes.list_heroes()

    case connected?(socket) do
      true ->
        connected_mount(draft_id, socket)

      false ->
        {:ok,
         assign(socket, %{username: username, draft: %DraftState{id: draft_id}, heroes: heroes})}
    end
  end

  def connected_mount(draft_id, socket) do
    username = get_connect_params(socket)["user_data"]["username"]
    heroes = Heroes.list_heroes()

    {:ok, draft_state} = DraftServer.join(draft_id, username)
    {:ok, assign(socket, %{username: username, draft: draft_state, heroes: heroes})}
  end

  @impl true
  def handle_event("change_side", %{"value" => side}, socket) do
    case DraftServer.change_side(socket.assigns.draft.id, socket.assigns.username, side) do
      {:ok, draft_state} ->
        {:noreply, assign(socket, %{draft: draft_state})}

      {:error, :side_full, draft_state} ->
        socket =
          put_flash(
            socket,
            :error,
            "#{String.capitalize(Atom.to_string(side))} has already been picked"
          )

        {:noreply, assign(socket, %{draft: draft_state})}
    end
  end

  @impl true
  def handle_event("pick_hero", %{"hero" => hero_id}, %{assigns: assigns} = socket) do
    {hero_id, ""} = Integer.parse(hero_id)

    case DraftServer.pick_hero(assigns.draft.id, hero_id, assigns.username) do
      {:ok, draft_state} ->
        {:noreply, assign(socket, %{draft: draft_state})}

      {:error, :already_picked, draft_state} ->
        socket =
          put_flash(
            socket,
            :error,
            "#{Enum.find(socket.assigns.heroes, fn x -> x.id == hero_id end).name} has already been picked"
          )

        {:noreply, assign(socket, %{draft: draft_state})}

      {:error, :not_side_turn, draft_state} ->
        socket =
          put_flash(
            socket,
            :error,
            "It is not your turn to pick"
          )

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

  def get_ring_color(type) do
    case type do
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
