defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BankWeb.Plugs.Auth
  end

  scope "/auth", BankWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/register", UsersController, :register
  end

  scope "/api/v1", BankWeb do
    pipe_through [:api, :auth]

    resources "/users", UsersController,
      only: [
        :index,
        :show,
        :update,
        :delete
      ]

    resources "/accounts", AccountsController,
      only: [
        :create
      ]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:bank, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BankWeb.Telemetry
    end
  end
end
