defmodule Bank.Users.User do
  import Ecto.Changeset
  use Ecto.Schema

  def fields, do: __MODULE__.__schema__(:fields) ++ __MODULE__.__schema__(:virtual_fields)

  @required_params [:name, :email, :password]
  schema "users" do
    field :name, :string
    field :email, :string
    field :cep, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(params) do
    fields = fields()

    %Bank.Users.User{}
    |> cast(params, fields)
    |> validate(@required_params)
    |> hash_password()
  end

  def changeset(struct, params) do
    fields = fields() -- [:password_hash]

    struct
    |> cast(params, fields)
    |> validate(@required_params -- [:password])
    |> hash_password()
  end

  defp validate(changeset, fields) do
    changeset
    |> validate_required(fields -- [:password])
    |> unique_constraint(:email)
    |> validate_length(:name, min: 3)
    |> validate_length(:password, min: 8)
    |> validate_length(:cep, is: 9)
  end

  @spec to_json(map()) :: map()
  def to_json(struct), do: struct |> to_json(:public)

  @spec to_json(map(), :public | :sensitive) :: map()
  def to_json(struct, _permission = :public) do
    struct
    |> Map.take([:name, :email])
  end

  def to_json(struct, _permission = :sensitive) do
    struct
    |> Map.take([:id, :name, :email, :password_hash, :inserted_at, :updated_at])
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(%{password_hash: Argon2.hash_pwd_salt(password)})
  end

  defp hash_password(changeset), do: changeset
end
