import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :kora_pay,
  public: System.get_env("PUBLIC_KEY", nil),
  private: System.get_env("PRIVATE_KEY", nil),
  redirect_url: System.get_env("REDIRECT_URL", nil),
  webhook_url: System.get_env("WEBHOOK_URL", nil),
  api: KoraPay.Client

import_config "#{config_env()}.exs"
