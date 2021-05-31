defmodule Captainsmode.StringHelper do
  def generate_random_hex(length) do
    alphabet = Enum.to_list(?a..?f) ++ Enum.to_list(?0..?9)
    for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>
  end
end
