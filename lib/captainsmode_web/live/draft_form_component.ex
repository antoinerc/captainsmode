defmodule CaptainsmodeWeb.DraftFormComponent do
  use CaptainsmodeWeb, :live_component

  import CaptainsmodeWeb.ErrorHelpers

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)
    configuration = Captainsmode.Drafts.change_configuration(%{})
    {:ok, assign(socket, configuration: configuration)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="p-6 flex flex-col space-y-5 bg-gray-900">
      <h1 class="text-2xl font-semibold text-white">
        Start a new draft
      </h1>
      <%= f = form_for @configuration, "#",
                as: :configuration,
                id: "user_form",
                phx_target: @myself,
                phx_submit: "create",
                phx_change: "validate" %>
        <div class="flex flex-col space-y-5">
          <div>
            <div class="input-label">Pick your side:</div>
            <div class="grid grid-flow-row grid-cols-3 grid-rows-1 gap-2 text-center">
              <%= for side <- ["random", "radiant", "dire"] do %>
              <%= radio_button f, :side, side, class: "hidden btn-radio-button" %>
              <label for="user_form_side_<%= side %>">
                <%= side %>
              </label>
              <% end %>
              <%= error_tag f, :side %>
            </div>
          </div>
          <div>
            <div class="input-label">Timer type:</div>
            <div class="grid grid-flow-row grid-cols-2 grid-rows-1 gap-2 text-center">
              <%= for timer_type <- ["default", "custom"] do %>
              <%= radio_button f, :timer_type, timer_type, class: "hidden btn-radio-button" %>
              <label for="user_form_timer_type_<%= timer_type %>">
                <%= timer_type %>
              </label>
              <% end %>
              <%= error_tag f, :timer_type %>
            </div>
          </div>
          <div class="custom-timers <%= if String.equivalent?(@configuration.changes.timer_type, 'custom'), do: '', else: 'hidden' %>">
            <div>
              <div class="input-label">Pick timer in seconds:</div>
              <%= number_input f, :pick_timer, class: "input" %>
              <%= error_tag f, :pick_timer %>
            </div>
            <div>
              <div class="input-label">Ban timer in seconds:</div>
              <%= number_input f, :ban_timer, class: "input" %>
              <%= error_tag f, :ban_timer %>
            </div>
            <div>
              <div class="input-label">Reserve timer in seconds:</div>
              <%= number_input f, :reserve_timer, class: "input" %>
              <%= error_tag f, :reserve_timer %>
            </div>
          </div>
          <%= submit "Start the draft", class: "btn-indigo" %>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"configuration" => data}, socket) do
    changeset =
      socket.assigns.configuration
      |> Captainsmode.Drafts.change_configuration(data)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, configuration: changeset)}
  end

  @impl true
  def handle_event("create", test, socket) do
    {:noreply, assign(socket, content: test)}
  end
end
