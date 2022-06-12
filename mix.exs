defmodule KoraPay.MixProject do
  use Mix.Project


  @source_url "https://github.com/hailelagi/korapay"
  @version "0.1.0"

  def project do
    [
      app: :kora_pay,
      version: @version,
      elixir: "~> 1.0",
      name: "korapay",
      source_url: @source_url,
      homepage_url: @source_url,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      { :elixir_uuid, "~> 1.2"},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:excoveralls, "~> 0.13", only: :test}
    ]
  end

    defp docs do
    [
      main: "KoraPay",
      logo: nil,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      description: "Korapay elixir client wrapper (https://docs.korapay.com/).",
      maintainers: ["hailelagi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end
end
