import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :kora_pay,
  public: nil,
  private: nil,
  webhook_url: nil,
  api: KoraPayMock
