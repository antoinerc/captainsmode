defmodule CaptainsmodeWeb.DraftFormComponent do
  use CaptainsmodeWeb, :live_component

  import CaptainsmodeWeb.ErrorHelpers
  alias Captainsmode.Drafts.DraftConfiguration

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)
    configuration = draft_configuration_to_data(DraftConfiguration.new())
    IO.puts("update")
    {:ok, assign(socket, data: configuration, configuration: DraftConfiguration.new(), valid: true)}
  end

  defp draft_configuration_to_data(dcfg) do
    %{"side" => dcfg.side, "timer_type" => dcfg.timer_type, "pick_timer" => dcfg.pick_timer, "ban_timer" => dcfg.ban_timer, "reserve_timer" => dcfg.reserve_timer}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="p-6 flex flex-col space-y-5">
      <h3 class="text-2xl font-semibold text-gray-800">
        Start a new draft
      </h3>
      <%= f = form_for :data, "#",
                as: :configuration,
                id: "user_form",
                phx_target: @myself,
                phx_submit: "create",
                phx_change: "validate" %>
        <div class="flex flex-col space-y-5">
          <div>
            <div class="input-label">Pick your side:</div>
            <%= select f, :side, value: ["random", "radiant", "dire"] %>
            <%= error_tag f, :side %>
          </div>
          <div>
            <div class="input-label">Timer type:</div>
            <%= select f, :timer_type, value: ["default", "custom"] %>
            <%= error_tag f, :timer_type %>
          </div>
          <div>
            <div class="input-label">Pick timer in seconds:</div>
            <%= number_input f, :pick_timer, value: @data["pick_timer"] %>
            <%= error_tag f, :pick_timer %>
          </div>
          <div>
            <div class="input-label">Ban timer in seconds:</div>
            <%= number_input f, :ban_timer, value: @data["ban_timer"] %>
            <%= error_tag f, :ban_timer %>
          </div>
          <div>
            <div class="input-label">Reserve timer in seconds:</div>
            <%= number_input f, :reserve_timer, value: @data["reserve_timer"] %>
            <%= error_tag f, :reserve_timer %>
          </div>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"data" => data}, socket) do
    {valid, configuration} =
      case DraftConfiguration.change(socket.assigns.configuration, data) do
        {:ok, configuration} -> {true, configuration}
        {:error, _errors, configuration} -> {false, configuration}
      end
    {:noreply, assign(socket, data: data, configuration: configuration, valid: valid)}
  end

  @impl true
  def handle_event("create", test, socket) do
    {:noreply, assign(socket, content: test)}
  end
end
