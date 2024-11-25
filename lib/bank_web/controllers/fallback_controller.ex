defmodule BankWeb.FallbackController do
  use BankWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: BankWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(json: BankWeb.ErrorJSON)
    |> render(:error, message: reason)
  end

  def call(conn, error = %Postgrex.Error{}) do
    conn
    |> put_status(:internal_server_error)
    |> render(:error, message: error.message)
  end
end
