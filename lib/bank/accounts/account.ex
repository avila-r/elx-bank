defmodule Bank.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset

  @fields [:user_id, :balance]
  schema "accounts" do
    belongs_to :user, Bank.Users.User
    field :balance, :decimal, default: 0

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required([:user_id])
    |> unique_constraint(:balance, name: :balance_must_be_positive)
    |> unique_constraint(:user_id, name: :account_unique_user_id)
  end

  @spec to_json(map()) :: map()
  def to_json(struct) do
    struct
    |> Map.take([:user_id, :balance, :inserted_at, :updated_at])
  end
end
