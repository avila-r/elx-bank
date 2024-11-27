defmodule Bank.Accounts do
  alias Bank.Repo
  alias Bank.Accounts.{Account, Transactions}

  @spec transfer(map()) :: {:error, any()} | {:ok, any()}
  defdelegate transfer(map),
    to: Transactions,
    as: :new

  @spec transfer(integer() | map(), integer() | map(), integer()) ::
          {:error, any()} | {:ok, any()}
  defdelegate transfer(from, to, quantity), to: Transactions, as: :new

  @spec list() :: {:error, String.t()} | {:ok, Ecto.Schema.t()}
  def list do
    with accounts when accounts != [] <- Account |> Repo.all() do
      {:ok, accounts}
    else
      [] -> {:error, "no accounts found"}
      _ -> {:error, "an unexpected error occurred"}
    end
  end

  def insert(params) do
    case params |> Account.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> Repo.insert(valid)
      invalid -> {:error, invalid}
    end
  end

  @spec get(integer() | map()) :: {:error, String.t()} | {:ok, Ecto.Schema.t()}
  def get(%{"id" => id}) when is_integer(id) do
    Account
    |> Repo.get(id)
    |> unwrap()
  end

  def get(%{"id" => id}) do
    case Integer.parse(id) do
      {parsed, ""} -> get(%{"id" => parsed})
      _ -> {:error, "id must be an integer"}
    end
  end

  def get(%{"email" => email}) when is_binary(email) do
    Account
    |> Repo.get_by(email: email)
    |> unwrap()
  end

  def get(id) when is_integer(id) do
    Account
    |> Repo.get(id)
    |> unwrap()
  end

  @spec unwrap(Ecto.Schema.t() | nil) :: {:error, String.t()} | {:ok, Ecto.Schema.t()}
  defp unwrap(result) do
    case result do
      nil -> {:error, "account not found"}
      account -> {:ok, account}
    end
  end
end
