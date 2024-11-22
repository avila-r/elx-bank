defmodule Bank.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  @table_name :users

  def up do
    create table(@table_name) do
      add :email,         :string, null: false, size: 30
      add :name,          :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(@table_name, [:email])
  end

  def down do
    drop table(@table_name)
  end
end
