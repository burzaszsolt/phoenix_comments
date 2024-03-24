defmodule PhoenixCommentsWeb.Router do
  use PhoenixCommentsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixCommentsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PhoenixCommentsWeb.Plugs.SetUser
  end

  pipeline :secured do
    plug(PhoenixCommentsWeb.Plugs.SetUser)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixCommentsWeb do
    pipe_through :browser

    get "/", PageController, :home
    post "/comments", PageController, :create
  end

  scope "/auth", PhoenixCommentsWeb do
    pipe_through(:browser)

    get("/signout", AuthController, :signout)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixCommentsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_comments, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixCommentsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
