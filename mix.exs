defmodule BookSearch.MixProject do
  use Mix.Project

  def project do
    [
      app: :book_search,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "BookSearch",
      source_url: "https://github.com/w40141/book_search"
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
      {:httpoison, "~> 1.8.0"},
      {:poison, "~> 5.0.0"},
      {:jason, "~> 1.2.2"}
    ]
  end

  defp escript_config do
    [
      main_module: BookSearch.CLI
    ]
  end
end
