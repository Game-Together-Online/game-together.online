defmodule GameTogetherOnlineWeb.Administration.SpyfallGameLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.SpyfallGames

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage spyfall_game records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="spyfall_game-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :table_id}} type="text" label="table" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Spyfall game</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{spyfall_game: spyfall_game} = assigns, socket) do
    changeset = SpyfallGames.change_spyfall_game(spyfall_game)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"spyfall_game" => spyfall_game_params}, socket) do
    changeset =
      socket.assigns.spyfall_game
      |> SpyfallGames.change_spyfall_game(spyfall_game_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"spyfall_game" => spyfall_game_params}, socket) do
    save_spyfall_game(socket, socket.assigns.action, spyfall_game_params)
  end

  defp save_spyfall_game(socket, :edit, spyfall_game_params) do
    case SpyfallGames.update_spyfall_game(socket.assigns.spyfall_game, spyfall_game_params) do
      {:ok, _spyfall_game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Spyfall game updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_spyfall_game(socket, :new, spyfall_game_params) do
    case SpyfallGames.create_spyfall_game(spyfall_game_params) do
      {:ok, _spyfall_game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Spyfall game created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
