defmodule TxtaiEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :txtai_ex,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      source_url: "https://github.com/nrrso/txtai_ex",
      homepage_url: "https://github.com/nrrso/txtai_ex",
      package: package(),
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TxtaiEx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description() do
    """
      txtai_ex` is an Elixir client library for [txtai](https://github.com/neuml/txtai),
      an AI-powered text search engine that enables building intelligent text-based applications in Elixir.
      With `txtai_ex`, you can seamlessly integrate natural language processing, embeddings search, and machine
      learning workflows into your Elixir projects.
    """
  end

  # Package configuration for Hex
  defp package do
    [
      files:
        ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE* license* CHANGELOG* changelog* src),
      maintainers: ["Norris Sam Osarenkhoe"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/nrrso/txtai_ex"}
      # Other package information...
    ]
  end
end
