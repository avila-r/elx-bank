defmodule Bank.Viacep.Client do
  @behaviour Bank.Viacep.ClientBehaviour

  use Tesla

  @default_url "https://viacep.com.br/ws"
  plug Tesla.Middleware.BaseUrl, @default_url
  plug Tesla.Middleware.JSON

  @impl Bank.Viacep.ClientBehaviour
  def validate(%Ecto.Changeset{changes: %{cep: cep}} = changeset) do
    case call(cep) do
      {:ok, _response} ->
        Ecto.Changeset.put_change(changeset, :cep, cep |> format())

      {:error, reason} ->
        Ecto.Changeset.add_error(changeset, :cep, reason)
        changeset
    end
  end

  def validate(changeset), do: changeset

  @impl Bank.Viacep.ClientBehaviour
  def call(url \\ @default_url, cep) do
    with {:ok, valid} <- trim(cep),
         {:ok, _response} = result <- "#{url}/#{valid}/json" |> get() |> handle() do
      result
    else
      {:error, _reason} = error -> error
    end
  end

  def format(cep) do
    String.replace(cep, ~r/^(\d{5})(\d{3})$/, "\\1-\\2")
  end

  def trim(cep) do
    cleaned = String.replace(cep, "-", "")

    with true <- is_binary(cleaned),
         true <- String.match?(cleaned, ~r/^\d{8}$/) do
      {:ok, cleaned}
    else
      _ -> {:error, "malformed cep"}
    end
  end

  defp handle({:ok, %Tesla.Env{status: 200, body: %{erro: true}}}),
    do: {:error, "cep wasn't found"}

  defp handle({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}

  defp handle({:ok, %Tesla.Env{status: 500}}), do: {:error, "missing or malformed cep"}
  defp handle({:error, reason}), do: {:error, reason}
end
