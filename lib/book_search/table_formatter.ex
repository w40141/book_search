defmodule TableFormatter do
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

  def widths_of(columns) do
    for column <- columns do
      Enum.map(column, fn(x) -> String.length(x) end)
      |> Enum.max()
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def format_for(column_widths) do
    Enum.map_join(column_widths, " | ", fn width -> "~-#{width}ts" end) <> "~n"
    |> to_charlist
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
    # IO.puts(is_list(fields))
    :io.format(format, fields)
  end
end
