defmodule Bank.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  @table_name :accounts

  def change do
    create table(@table_name) do
      add :user_id, references(:users)
      add :balance, :decimal

      timestamps()
    end

    create constraint(@table_name, :balance_must_be_positive, check: "balance >= 0")
  end
end
