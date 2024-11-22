defmodule Bank.Users do
  alias Bank.Repo
  alias Bank.Users.User

  def create(%{"email" => email} = new) do
    case find_by_email(email) do
      {:ok, _user} ->
        {:error, message: "user already registered with this email"}

      {:error, _reason} ->
        changeset = new |> User.changeset()

        case changeset do
          %Ecto.Changeset{valid?: true} -> Repo.insert(changeset)
          _ -> {:error, changeset: changeset}
        end
    end
  end

  def find_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end
end
