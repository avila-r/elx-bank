defmodule BankWeb.UsersJSON do
  alias Bank.Users.User

  def create(%{user: user}) do
    %{
      message: "successfully created user",
      data: data(user)
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
