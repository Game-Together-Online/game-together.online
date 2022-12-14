defmodule GameTogetherOnline.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    presence_server = Application.get_env(:game_together_online, :presence_server)

    children = [
      # Start the Telemetry supervisor
      GameTogetherOnlineWeb.Telemetry,
      # Start the Ecto repository
      GameTogetherOnline.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GameTogetherOnline.PubSub},
      # Start Finch
      {Finch, name: GameTogetherOnline.Finch},
      # Start the Endpoint (http/https)
      GameTogetherOnlineWeb.Endpoint,
      # Start a worker by calling: GameTogetherOnline.Worker.start_link(arg)
      # {GameTogetherOnline.Worker, arg}
      GameTogetherOnline.Tables.Presence,
      presence_server
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameTogetherOnline.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GameTogetherOnlineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
