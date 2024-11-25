defmodule Bank.Viacep.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws/"

  def validate(%Ecto.Changeset{changes: %{cep: cep}} = changeset) do
    case call(cep) do
      {:ok, _response} ->
        Ecto.Changeset.put_change(changeset, :cep, cep |> format())

      {:error, reason} ->
        Ecto.Changeset.add_error(changeset, :cep, reason)
        changeset
    end
  end

  defp call(cep) do
    with {:ok, valid} <- trim(cep),
         {:ok, _response} = result <- "#{valid}/json" |> get() |> handle() do
      result
    else
      {:error, _reason} = error -> error
    end
  end

  defp format(cep) do
    String.replace(cep, ~r/^(\d{5})(\d{3})$/, "\\1-\\2")
  end

  defp trim(cep) do
    with true <- is_binary(cep),
         true <- String.match?(cep, ~r/^\d{8}$/) do
      {:ok, cep}
    else
      _ -> {:error, "malformed cep"}
    end
  end

  defp handle({:ok, %Tesla.Env{status: 200, body: %{erro: true}}}),
    do: {:error, "cep wasn't found"}

  defp handle({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle({:ok, %Tesla.Env{status: 400}}), do: {:error, "missing or malformed cep"}
  defp handle({:error, _}), do: {:error, "unexpected error occurred"}
end
