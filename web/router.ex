defmodule RestApi.Router do
  use RestApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RestApi do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/posts", PostController
    end
  end
  #other
  scope "/api/v1", as: :api_v1, alias: API.V1 do
  get "/pages/:id", PageController, :show
  end
end
