import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :kora_pay,
  public: System.get_env("PUBLIC_KEY"),
  private: System.get_env("PRIVATE_KEY"),
  webhook_url: System.get_env("WEBHOOK_URL"),
  api: KoraPay.Client

import_config "#{config_env()}.exs"
