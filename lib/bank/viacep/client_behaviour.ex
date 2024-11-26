defmodule Bank.Viacep.ClientBehaviour do
  @callback call(String.t()) :: {:error, String.t()} | {:ok, any()}
  @callback validate(Ecto.Changeset.t()) :: Ecto.Changeset.t()
end
