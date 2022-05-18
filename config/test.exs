import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :kora_pay,
  public_key: "test",
  private_key: "test"
