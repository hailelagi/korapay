# KoraPay

Korapay client (https://docs.korapay.com/).

## Testing
Mock tests run by default with:
```bash
mix test
```

If test api keys have been configured you may run tests against the sandbox with:

```elixir
mix test --include sandbox:true
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kora_pay` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kora_pay, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kora_pay>.

