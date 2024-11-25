defmodule Bank.Repo.Migrations.AddUserCepColumn do
  use Ecto.Migration

  @table_name :users

  def up do
    alter table(@table_name) do
      add :cep, :string, size: 9
    end
  end

  def down do
    alter table(@table_name) do
      remove :cep
    end
  end
end
