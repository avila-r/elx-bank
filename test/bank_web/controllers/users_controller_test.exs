defmodule BankWeb.UsersControllerTest do
  # Enable both connection mode and
  # SQL sandbox mode.
  #
  # OBS:
  # SQL sandbox for data sources
  # asserts transaction environment.
  use BankWeb.ConnCase

  alias Bank.Viacep

  import Mox

  setup do
    body = %{
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

    {:ok, cep: "36016320", expected_body: body}
  end

  describe "create/2" do
    test "successfully creates user", %{conn: conn, cep: cep, expected_body: body} do
      params = %{
        name: "Renato Ávila",
        email: "avila.,dev@outlook.com",
        password: "12345678",
        cep: cep
      }

      expect(Viacep.ClientMock, :call, fn _cep ->
        {:ok, body}
      end)

      expect(Viacep.ClientMock, :validate, fn changeset ->
        changeset
        |> Ecto.Changeset.put_change(
          :cep,
          cep
          |> Viacep.Client.format()
        )
      end)

      response =
        conn
        |> post("/api/v1/users", params)
        |> json_response(:created)

      assert %{
               "id" => _id,
               "name" => _name,
               "email" => _email,
               "password_hash" => _hash,
               "inserted_at" => _created_at,
               "updated_at" => _updated_at
             } = response
    end

    test "when invalid params are provided, then returns an error", %{
      conn: conn
    } do
      expect(Viacep.ClientMock, :call, fn _cep ->
        {:ok, %{}}
      end)

      expect(Viacep.ClientMock, :validate, 2, fn changeset ->
        changeset
      end)

      email = "avila.dev@outlook.com"

      conn
      |> post("/api/v1/users", %{
        name: "Renato Ávila",
        email: email,
        password: "12345678"
      })
      |> json_response(:created)

      invalid = %{
        # Short name
        name: "Re",
        # Non-unique email
        email: email,
        # Short password
        password: "1234567"
      }

      response =
        conn
        |> post("/api/v1/users", invalid)
        |> json_response(:unprocessable_entity)

      assert %{"errors" => _} = response
    end
  end
end
