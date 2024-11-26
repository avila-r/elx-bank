defmodule Bank.Accounts do
  alias Bank.Repo
  alias Bank.Accounts.Account

  def insert(params) do
    case params |> Account.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> Repo.insert(valid)
      invalid -> {:error, invalid}
    end
  end
end
