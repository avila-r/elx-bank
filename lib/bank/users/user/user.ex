defmodule Bank.Users.User do
  import Ecto.Changeset
  use Ecto.Schema

  @required_params [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 3)
    |> validate_length(:password, min: 8)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(%{password_hash: Argon2.hash_pwd_salt(password)})
  end

  defp hash_password(changeset), do: changeset
end
