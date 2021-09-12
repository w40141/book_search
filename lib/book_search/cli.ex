defmodule BookSearch.CLI do
  # import TableFormatter, only: [print_table_for_columns: 2]

  @default_count 10

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the information of _n_ books in a search
  by google API
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

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

    # |> print_table_for_columns(["authors", "created_at", "title"])
  end
end
