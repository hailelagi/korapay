import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :kora_pay,
  public_key: nil,
  private_key: nil

import_config "#{config_env()}.exs"
