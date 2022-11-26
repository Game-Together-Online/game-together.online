defmodule GameTogetherOnlineWeb.TableLive.ChangeNicknameComponent do
  use GameTogetherOnlineWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Change Your Nickname
      </.header>

      <.simple_form
        :let={f}
        for={:whatever}
        id="change-nickname-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :status}} type="text" />

        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
