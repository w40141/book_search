defmodule BookSearch.CLI do
  import TableFormatter, only: [print_table_for_columns: 2]

  @default_count 10

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the information of _n_ books in a search
  by google API
  """

  def default_header(), do: ["authors", "title", "pageCount", "ISBN_10", "ISBN_13"]

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally) the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation([keyword]) do
    {keyword, @default_count}
  end

  defp args_to_internal_representation([keyword, count]) do
    {keyword, String.to_integer(count)}
  end

  defp args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: book_search <keyword> [ count | #{@default_count} ]
    """)
  end

  def process({keyword, count}) do
    BookSearch.SearchGoogle.fetch(keyword, count)
    |> BookSearch.DecodeResponse.decode_response()
    |> print_table_for_columns(default_header())
  end
end
