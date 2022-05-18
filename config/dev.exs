import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :kora_pay,
  public_key: "dev",
  private_key: "dev"
