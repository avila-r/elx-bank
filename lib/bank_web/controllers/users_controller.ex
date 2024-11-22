defmodule BankWeb.UsersController do
  use BankWeb, :controller
  alias Bank.Users

  def create(conn, new) do
    new
    |> Users.create()
    |> case do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(:create, user: user)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> put_view(json: BankWeb.ErrorJSON)
        |> render(:error, reason)
    end
  end
end
