defmodule PraElixir.Google do
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

end
