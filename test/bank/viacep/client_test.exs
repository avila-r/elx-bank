defmodule Bank.Viacep.ClientTest do
  use ExUnit.Case, async: true

  alias Bank.Viacep

  setup do
    expected_body = %{
      "bairro" => "Centro",
      "cep" => "36016-320",
      "complemento" => "de 1201/1202 a 1599/1600",
      "ddd" => "32",
      "estado" => "Minas Gerais",
      "gia" => "",
      "ibge" => "3136702",
      "localidade" => "Juiz de Fora",
      "logradouro" => "Avenida Presidente Itamar Franco",
      "regiao" => "Sudeste",
      "siafi" => "4733",
      "uf" => "MG",
      "unidade" => ""
    }

    {:ok, bypass: Bypass.open(), expected_body: expected_body}
  end

  defp url(port), do: "http://localhost:#{port}"

  describe "call/1" do
    test "successfully validate cep", %{bypass: bypass, expected_body: body} do
      bypass
      |> Bypass.expect("GET", "/36016320/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body |> Jason.encode!())
      end)

      response =
        bypass.port
        |> url()
        |> Viacep.Client.call("36016-320")

      assert response == {:ok, body}
    end
  end
end
