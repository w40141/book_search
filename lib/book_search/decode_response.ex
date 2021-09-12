defmodule BookSearch.DecodeResponse do
  def decode_response({:ok, body}) do
    body
    |> format_json()
  end

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Google: #{error["message"]}")
    System.halt(2)
  end

  def format_json(response_decoded) do
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
    {identifies, org} = Map.split(map, ["industryIdentifiers"])

    Map.merge(org, format_identifier(identifies))
    |> Map.take(["authors", "title", "pageCount", "ISBN_10", "ISBN_13"])
  end

  defp format_identifier(map) do
    Enum.reduce(map["industryIdentifiers"], %{}, fn x, acc ->
      Map.merge(%{x["type"] => x["identifier"]}, acc)
    end)
  end
end
