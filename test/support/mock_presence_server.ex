defmodule GameTogetherOnline.MockPresenceServer do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end
end
