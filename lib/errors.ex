defmodule Errors do
  use BankWeb, :controller

  def send(conn, status) do
    conn
    |> put_status(status)
    |> send_resp()
  end

  def send(conn, status, error) do
    conn
    |> put_status(status)
    |> put_view(BankWeb.ErrorJSON)
    |> render(:error, error)
  end
end
