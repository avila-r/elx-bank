defmodule BankWeb.AuthController do
  use BankWeb, :controller

  action_fallback BankWeb.FallbackController

  alias Bank.{Users, Users.User, Token}

  def login(conn, params) do
    case Users.login(params) do
      {:ok, user} ->
        conn
        |> json(%{
          bearer: user |> Token.new(),
          user: user |> User.to_json()
        })

      {:error, :unauthorized} ->
        conn
        |> Errors.send(:unauthorized)

      {:error, reason} ->
        conn
        |> Errors.send(:not_found, message: reason)
    end
  end
end
