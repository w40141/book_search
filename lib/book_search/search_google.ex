defmodule BookSearch.SearchGoogle do
  require Logger
  require HTTPoison
  require Jason

  def fetch(keyword, count) do
    Logger.info("Fetching #{keyword}: #{count}")

    books_search_url(keyword, count)
    |> HTTPoison.get()
    |> handle_response()
  end

  defp books_search_url(keyword, count) do
    "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=#{count}"
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
end
