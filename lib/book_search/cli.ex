defmodule BookSearch.CLI do
  import TableFormatter, only: [print_table_for_columns: 2]

  # @default_count 10

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the information of _n_ books in a search
  by google API
  """

  def main(argv) do
    argv
    # |> parse_args
    |> process
  end

  def process(:help) do
    # IO.puts("""
    # usage: issues <keyword> [ count | #{@default_count} ]
    # """)
    IO.puts("""
    usage: issues <keyword>
    """)
  end

  def process(keyword) do
    BookSearch.Google.fetch(keyword)
    |> decode_response()
    |> print_table_for_columns(["authors", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from GoogleGithub: #{error["message"]}")
    System.halt(2)
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
    {keyword}
    # {user, project, String.to_integer(count)}
  end

  # def args_to_internal_representation([user, project]) do
  #   {user, project, @default_count}
  # end

  defp args_to_internal_representation(_) do
    :help
  end
end
