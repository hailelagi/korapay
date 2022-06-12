# KoraPay

Korapay client (https://docs.korapay.com/). Documentation can be found at <https://hexdocs.pm/kora_pay>.

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

Package can be installed by adding `kora_pay` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kora_pay, "~> 0.1.0"}
  ]
end
```

