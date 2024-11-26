alias Bank.Viacep.ClientBehaviour

Mox.defmock(Bank.Viacep.ClientMock, for: ClientBehaviour)
Application.put_env(:bank, :viacep_client, Bank.Viacep.ClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Bank.Repo, :manual)
