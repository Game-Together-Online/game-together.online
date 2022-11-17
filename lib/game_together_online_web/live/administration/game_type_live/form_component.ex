defmodule GameTogetherOnlineWeb.Administration.GameTypeLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.GameTypes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage game_type records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="game_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :description}} type="text" label="description" />
        <.input field={{f, :slug}} type="text" label="slug" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Game type</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{game_type: game_type} = assigns, socket) do
    changeset = GameTypes.change_game_type(game_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"game_type" => game_type_params}, socket) do
    changeset =
      socket.assigns.game_type
      |> GameTypes.change_game_type(game_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"game_type" => game_type_params}, socket) do
    save_game_type(socket, socket.assigns.action, game_type_params)
  end

  defp save_game_type(socket, :edit, game_type_params) do
    case GameTypes.update_game_type(socket.assigns.game_type, game_type_params) do
      {:ok, _game_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game type updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_game_type(socket, :new, game_type_params) do
    case GameTypes.create_game_type(game_type_params) do
      {:ok, _game_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game type created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
