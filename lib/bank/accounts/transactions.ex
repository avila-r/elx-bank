defmodule Bank.Accounts.Transactions do
  alias Bank.{Repo, Accounts, Accounts.Account}
  alias Ecto.Multi
  alias Decimal

  @spec new(map()) :: {:error, any()} | {:ok, any()}
  def new(%{"from" => from, "to" => to, "quantity" => quantity}), do: new(from, to, quantity)

  @spec new(integer() | map(), integer() | map(), integer()) ::
          {:error, any()} | {:ok, any()}
  def new(from, to, quantity) do
    with {{:ok, sender}, {:ok, receiver}} <- {Accounts.get(from), Accounts.get(to)},
         {:ok, value} <- Decimal.cast(quantity) do
      Multi.new()
      |> withdraw(sender, value)
      |> deposit(receiver, value)
      |> confirm()
    else
      fail -> handle(fail)
    end
  end

  defp withdraw(group, %{balance: current} = target, value) do
    group
    |> Multi.update(
      :withdraw,
      target
      |> Account.changeset(%{
        balance: current |> Decimal.sub(value)
      })
    )
  end

  defp deposit(group, %{balance: current} = target, value) do
    group
    |> Multi.update(
      :deposit,
      target
      |> Account.changeset(%{
        balance: current |> Decimal.add(value)
      })
    )
  end

  defp confirm(transaction) do
    case transaction |> Repo.transaction() do
      {:ok, _} = ok -> ok
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp handle(fail) do
    case fail do
      :error ->
        {:error, "missing or malformed transaction's value"}

      {{:error, _}, {:ok, _}} ->
        {:error, "sender not found"}

      {{:ok, _}, {:error, _}} ->
        {:error, "receiver not found"}

      {{:error, _}, {:error, _}} ->
        {:error, "both sender and receiver weren't found"}
    end
  end
end
