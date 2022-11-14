defmodule GameTogetherOnlineWeb.Router do
  use GameTogetherOnlineWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GameTogetherOnlineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameTogetherOnlineWeb do
    pipe_through :browser

    scope "/tables", TableLive do
      live "/:id/lobby", Index, :lobby
    end

    scope "/administration", Administration do
      scope "/tables", TableLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end
    end

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameTogetherOnlineWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:game_together_online, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GameTogetherOnlineWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
