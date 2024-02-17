[![Hex Version](https://img.shields.io/hexpm/v/txtai_ex.svg)](https://hex.pm/packages/txtai_ex)

# txtai_ex

`txtai_ex` is an Elixir client library for [txtai](https://github.com/neuml/txtai), an AI-powered text search engine that enables building intelligent text-based applications in Elixir. With `txtai_ex`, you can seamlessly integrate natural language processing, embeddings search, and machine learning workflows into your Elixir projects.

## Features

- **Embeddings Search**: Perform semantic search operations to find the most relevant pieces of text that match a query.
- **Text Summarization**: Automatically summarize long pieces of text.
- **Text Translation**: Translate text from one language to another.
- **Text Extraction**: Extract text from various file formats.
- **Workflow Automation**: Execute named workflows to process data.

## Installation

To start using `txtai_ex`, add it to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:txtai_ex, "~> 0.1.0"}
  ]
end
```

Then, run `mix deps.get` to fetch the new dependency.

## Usage

Here's a quick example to get you started with `txtai_ex`:

```elixir
alias TxtaiEx.{Api, Embeddings}

# Initialize the API
api = Api.new("http://localhost:8000", "YourAPIToken")

# Perform an embeddings search
results = Embeddings.search(api, "Elixir", 5)
IO.inspect(results)
```

## Documentation

For detailed documentation on all features and functionalities, visit https://hexdocs.pm/txtai_ex/readme.html.

## Contributing

Contributions to `txtai_ex` are welcome and appreciated. If you're interested in contributing, please:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes.
4. Push to your fork and submit a pull request.

Before contributing, please check out our [contributing guidelines](CONTRIBUTING.md).

## Support

If you encounter any issues or have questions, please file an issue on the GitHub issue tracker.

## License

`txtai_ex` is released under the Apache 2.0 License. See the [LICENSE](LICENSE) file for more details.

---
