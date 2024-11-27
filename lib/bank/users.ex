defmodule Bank.Users do
  alias Bank.{Repo, Users.User, Users.Password}

  @spec login(map()) ::
          {:ok, %Bank.Users.User{}} | {:error, :unauthorized | String.t()}
  defdelegate login(request), to: Password, as: :check

  def list() do
    with users when users != [] <- Repo.all(User) do
      {:ok, users}
    else
      [] -> {:error, "no users found"}
      _ -> {:error, "an unexpected error occurred"}
    end
  end

  def insert(params) do
    case params |> User.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> valid |> Repo.insert()
      invalid -> {:error, invalid}
    end
  end

  def update(params) do
    case get(params) do
      {:ok, user} ->
        user
        |> User.changeset(params)
        |> Repo.update()

      {:error, _reason} = error ->
        error
    end
  end

  def delete(%{"id" => id}) do
    with {:ok, user} <- get(id),
         {:ok, _} <- Repo.delete(user) do
      {:ok}
    else
      {:error, _reason} = error -> error
    end
  end

  @spec get(any()) :: {:error, String.t()} | {:ok, any()}
  def get(%{"id" => id}) when is_integer(id) do
    case Repo.get(User, id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get(%{"id" => id}) do
    case Integer.parse(id) do
      {parsed, ""} -> get(%{"id" => parsed})
      _ -> {:error, "id must be an integer"}
    end
  end

  def get(%{"email" => email}) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get(id) when is_integer(id) do
    case Repo.get(User, id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get(%{"email" => _email}), do: {:error, "missing or malformed email"}
  def get(_id), do: {:error, "missing or invalid id"}
end
