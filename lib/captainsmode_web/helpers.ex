defmodule CaptainsmodeWeb.Helpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `Livebook.ModalComponent` component.
  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_class = Keyword.get(opts, :modal_class)

    modal_opts = [
      id: :modal,
      return_to: path,
      modal_class: modal_class,
      component: component,
      opts: opts
    ]

    live_component(socket, CaptainsmodeWeb.ModalComponent, modal_opts)
  end
end
