defmodule GameTogetherOnlineWeb.Router do
  use GameTogetherOnlineWeb, :router

  import GameTogetherOnlineWeb.UserAuth
  import GameTogetherOnlineWeb.Player

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GameTogetherOnlineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_player
    plug :ensure_current_player_exists
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameTogetherOnlineWeb do
    pipe_through :browser

    live_session :current_player,
      on_mount: [{GameTogetherOnlineWeb.PlayerLive, :mount_current_player}],
      root_layout: {GameTogetherOnlineWeb.Layouts, :full_screen} do
      scope "/tables", TableLive do
        live "/:id/lobby", Index, :lobby, container: {:div, class: "h-full"}
      end
    end

    scope "/administration", Administration do
      get "/", PageController, :home

      scope "/spyfall_participants", SpyfallParticipantLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/spyfall", Spyfall do
        live "/locations", LocationLive.Index, :index
        live "/locations/new", LocationLive.Index, :new
        live "/locations/:id/edit", LocationLive.Index, :edit

        live "/locations/:id", LocationLive.Show, :show
        live "/locations/:id/show/edit", LocationLive.Show, :edit
      end

      scope "/nickname_change_events", NicknameChangeEventLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/presence_events", PresenceEventLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/chats", ChatLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/spyfall/games", SpyfallGameLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/chat_messages", ChatMessageLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/users", UserLive do
        live "/", Index, :index
        live "/:id", Show, :show
      end

      scope "/roles", RoleLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/players", PlayerLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/tables", TableLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/game_types", GameTypeLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end
    end

    live "/", PageLive.Index, :home
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

  ## Authentication routes

  scope "/", GameTogetherOnlineWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{GameTogetherOnlineWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", GameTogetherOnlineWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{GameTogetherOnlineWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", GameTogetherOnlineWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{GameTogetherOnlineWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
