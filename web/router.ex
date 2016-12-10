defmodule Unlocked.Router do
  use Unlocked.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Unlocked do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", Unlocked do
    pipe_through :browser

    get "/:provider/", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/score", Unlocked do
    pipe_through :browser

    get "/", AuthController, :index
    get "/:provider/request", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Unlocked do
  #   pipe_through :api
  # end
end
