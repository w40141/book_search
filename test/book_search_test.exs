defmodule BookSearchTest do
  use ExUnit.Case
  doctest BookSearch

  test "greets the world" do
    assert BookSearch.hello() == :world
  end
end
