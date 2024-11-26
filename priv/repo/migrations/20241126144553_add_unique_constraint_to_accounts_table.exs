defmodule Bank.Repo.Migrations.AddUniqueConstraintToAccountsTable do
  use Ecto.Migration

  @table :accounts
  @constraint :account_unique_user_id
  @targets [:user_id]

  def change do
    create unique_index(@table, @targets, name: @constraint)
  end
end
