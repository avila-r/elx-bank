defmodule BankWeb.Plugs.Auth do
  import Plug.Conn

  alias Bank.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- conn |> get_req_header("authorization"),
         {:ok, context} <- token |> Token.verify() do
      conn |> assign(:user_id, context)
    else
      _ ->
        conn
        |> Errors.send(:unauthorized)
        |> halt()
    end
  end
end
