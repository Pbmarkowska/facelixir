defmodule FacelixirWeb.Router do
  use FacelixirWeb, :router

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

  scope "/", FacelixirWeb do
    pipe_through :browser # Use the default browser stack
    resources "/users", UserController
    get "/download", UserController, :download
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FacelixirWeb do
  #   pipe_through :api
  # end
end
