defmodule Bank.Token do
  alias Phoenix.Token

  @context Bank.Endpoint
  @salt "salt"

  def new(user), do: @context |> Token.sign(@salt, user)

  def verify(token), do: @context |> Token.verify(@salt, token)
end
