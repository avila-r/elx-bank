defmodule BankWeb.AccountsController do
  use BankWeb, :controller

  alias Bank.{Accounts, Accounts.Account}

  action_fallback BankWeb.FallbackController

  def create(conn, params) do
    case params |> Accounts.insert() do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> json(account |> Account.to_json())

      {:error, changeset} ->
        conn
        |> Errors.send(:unprocessable_entity, changeset: changeset)
    end
  end
end
