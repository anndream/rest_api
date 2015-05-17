defmodule RestApi.V1.PostControllerTest do
  use RestApi.ConnCase

  alias RestApi.Post
  @valid_params post: %{content: "some content", title: "some content"}
  @invalid_params post: %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "GET /posts", %{conn: conn} do
    conn = get conn, v1_post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "GET /posts/:id", %{conn: conn} do
    post = Repo.insert %Post{}
    conn = get conn, v1_post_path(conn, :show, post)
    assert json_response(conn, 200)["data"] == %{
      "id" => post.id
    }
  end

  test "POST /posts with valid data", %{conn: conn} do
    conn = post conn, v1_post_path(conn, :create), @valid_params
    assert json_response(conn, 200)["data"]["id"]
  end

  test "POST /posts with invalid data", %{conn: conn} do
    conn = post conn, v1_post_path(conn, :create), @invalid_params
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "PUT /posts/:id with valid data", %{conn: conn} do
    post = Repo.insert %Post{}
    conn = put conn, v1_post_path(conn, :update, post), @valid_params
    assert json_response(conn, 200)["data"]["id"]
  end

  test "PUT /posts/:id with invalid data", %{conn: conn} do
    post = Repo.insert %Post{}
    conn = put conn, v1_post_path(conn, :update, post), @invalid_params
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "DELETE /posts/:id", %{conn: conn} do
    post = Repo.insert %Post{}
    conn = delete conn, v1_post_path(conn, :delete, post)
    assert json_response(conn, 200)["data"]["id"]
    refute Repo.get(Post, post.id)
  end
end
