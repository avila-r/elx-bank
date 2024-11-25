defmodule BankWeb.UsersControllerTest do
  # Enable both connection mode and
  # SQL sandbox mode.
  #
  # OBS:
  # SQL sandbox for data sources
  # asserts transaction environment.
  use BankWeb.ConnCase

  describe "create/2" do
    test "successfully creates user", %{conn: conn} do
      params = %{
        name: "Renato Ávila",
        email: "avila.dev@outlook.com",
        password: "12345678"
      }

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

    test "when invalid params are provided, then returns an error", %{conn: conn} do
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
