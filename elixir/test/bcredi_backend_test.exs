defmodule BcrediBackendTest do
  use ExUnit.Case
  doctest BcrediBackend

  test "the entire solution" do
    IO.puts("\n")
    for iteration <- 0..12 do
      test_number =
        iteration
        |> Integer.to_string()
        |> String.pad_leading(3, "0")

      {:ok, content} =
        Path.expand("../test/input/input" <> test_number <> ".txt")
        |> File.read()

      messages = content |> String.split("\n", trim: true)

      {:ok, output} =
        Path.expand("../test/output/output" <> test_number <> ".txt")
        |> File.read()

      assert BcrediBackend.solution(messages) == output
      IO.puts("Test #" <> test_number <> " 🍻")
    end
  end
end
