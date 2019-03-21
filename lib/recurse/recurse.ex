defmodule Recurse do
  def loopy([head | tail] = list) do
    loopy(tail)
  end
end

Recurse.loopy([1, 2, 3, 4, 5])
