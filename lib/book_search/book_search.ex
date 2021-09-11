defmodule PraElixir.BookSearch do
  require Logger
  require HTTPoison
  require Jason

  def fetch(keyword) do
    Logger.info("Fetching #{keyword}")

    books_search_url(keyword)
    |> HTTPoison.get()
    |> handle_response()
  end

  defp books_search_url(keyword) do
    "https://www.googleapis.com/books/v1/volumes?q=#{keyword}"
  end

  defp handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status code=#{status_code}")

    {
      status_code |> check_for_error,
      body |> Jason.decode!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def main(argv) do
    argv
    # |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation([keyword]) do
    {keyword}
  end

  defp args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: issues <keyword>
    """)
  end

  def process(keyword) do
    fetch(keyword)
    |> decode_response()
    |> table_formatter()
  end

  def table_formatter(response_decoded) do
    convert_json_to_list(response_decoded)
  end

  defp convert_json_to_list(response_decoded) do
    response_decoded
    |> get_items()
    |> get_books_info()
  end

  defp get_items(map) do
    map["items"]
  end

  defp get_books_info(list) do
    Enum.map(list, fn x -> filter_book_info(x["volumeInfo"]) end)
  end

  defp filter_book_info(map) do
    Map.take(map, ["authors", "title", "pageCount", "industryIdentifiers"])
  end

  # defp filter_isbn(industryIdentifiers) do
  #   
  # end

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths = widths_of(data_by_columns),
         format = format_for(column_widths) do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns do
      column
      |> Enum.map(&String.length/1)
      |> Enum.max()
    end
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    Enum.map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
