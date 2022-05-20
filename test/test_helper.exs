Mox.defmock(KoraPayMock, for: KoraPay.Behaviour)
Application.get_env(:kora_pay, :api, KoraPayMock)

ExUnit.start()
