defmodule Bank.Users.Password do
  import Argon2

  alias Bank.Users

  @spec check(map()) :: {:ok, %Bank.Users.User{}} | {:error, :unauthorized | String.t()}
  def check(%{"password" => password} = params) do
    case Users.get(params) do
      {:ok, user} ->
        case verify_pass(password, user.password_hash) do
          true -> {:ok, user}
          false -> {:error, :unauthorized}
        end

      {:error, _} = error ->
        error
    end
  end
end
