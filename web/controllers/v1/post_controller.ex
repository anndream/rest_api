defmodule RestApi.V1.PostController do
  use RestApi.Web, :controller

  alias RestApi.Post

  plug :scrub_params, "post" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    if changeset.valid? do
      post = Repo.insert(changeset)
      render(conn, "show.json", post: post)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(RestApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render conn, "show.json", post: post
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post, post_params)

    if changeset.valid? do
      post = Repo.update(changeset)
      render(conn, "show.json", post: post)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(RestApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get(Post, id)

    post = Repo.delete(post)
    render(conn, "show.json", post: post)
  end
end
