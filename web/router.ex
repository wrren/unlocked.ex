defmodule Unlocked.Router do
  use Unlocked.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Unlocked.Plug.Authenticate, %{ :path => "/auth", :redirect => "/auth/google" }
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Unlocked do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/",  PageController, :score

    get "/user", UserController, :index
    get "/user/:id", UserController, :show
    get "/user/search/:term", UserController, :search
  end

  scope "/scoreboard", Unlocked do
    pipe_through :browser

    get "/", ScoreboardController, :recent
    get "/top/", ScoreboardController, :top_all_time
    get "/top/:interval", ScoreboardController, :top
  end

  scope "/auth", Unlocked do
    pipe_through :browser

    get "/:provider/", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Unlocked do
  #   pipe_through :api
  # end
end
