defmodule GameTogetherOnlineWeb.Administration.TableLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.Tables

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage table records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="table-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :status}} type="text" label="status" />

        <.input type="select" field={{f, :game_type_id}} label="game type" options={@game_types} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Table</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{table: table} = assigns, socket) do
    changeset = Tables.change_table(table)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"table" => table_params}, socket) do
    changeset =
      socket.assigns.table
      |> Tables.change_table(table_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"table" => table_params}, socket) do
    save_table(socket, socket.assigns.action, table_params)
  end

  defp save_table(socket, :edit, table_params) do
    case Tables.update_table(socket.assigns.table, table_params) do
      {:ok, _table} ->
        {:noreply,
         socket
         |> put_flash(:info, "Table updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_table(socket, :new, table_params) do
    case Tables.create_table(table_params) do
      {:ok, _table} ->
        {:noreply,
         socket
         |> put_flash(:info, "Table created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
