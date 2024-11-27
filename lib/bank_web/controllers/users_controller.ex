defmodule BankWeb.UsersController do
  use BankWeb, :controller

  action_fallback BankWeb.FallbackController

  alias Bank.{Users, Users.User}

  def index(conn, %{"email" => _email} = params),
    do: conn |> show(params)

  def index(conn, %{"id" => _id} = params),
    do: conn |> show(params)

  def index(conn, _params) do
    case Users.list() do
      {:ok, users} ->
        conn
        |> json(users |> Enum.map(&Users.User.to_json/1))

      {:error, reason} ->
        conn
        |> Errors.send(:not_found, message: reason)
    end
  end

  def show(conn, params) do
    case params |> Users.get() do
      {:ok, user} ->
        conn
        |> json(user |> User.to_json(:sensitive))

      {:error, reason} ->
        conn
        |> Errors.send(:not_found, message: reason)
    end
  end

  def create(conn, params) do
    case params |> Users.insert() do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user |> User.to_json(:sensitive))

      {:error, changeset} ->
        conn
        |> Errors.send(:unprocessable_entity, changeset: changeset)
    end
  end

  def update(conn, params) do
    case params |> Users.update() do
      {:ok, user} ->
        conn
        |> json(user |> User.to_json(:sensitive))

      {:error, changeset} ->
        conn
        |> Errors.send(:unprocessable_entity, changeset: changeset)
    end
  end

  def delete(conn, params) do
    case params |> Users.delete() do
      {:ok} ->
        conn
        |> send_resp(:no_content, "")

      {:error, reason} ->
        conn
        |> Errors.send(:bad_request, message: reason)
    end
  end
end
