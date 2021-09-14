defmodule CliTest do
  use ExUnit.Case
  doctest BookSearch

  import BookSearch.CLI,
    only: [
      parse_args: 1,
    ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args([ "-h" ]) == :help
    assert parse_args([ "--help" ]) == :help
  end

  test "three values returned if three given" do
    assert parse_args([ "user", "99" ]) == { "user", 99 }
  end

  test "count is defaulted if two valuse given" do
    assert parse_args([ "user" ]) == { "user", 10 }
  end

end
