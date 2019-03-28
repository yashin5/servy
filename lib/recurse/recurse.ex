defmodule Recurse do
  def loopy([head | tail] = list) when is_number(head) do
    IO.puts("#{head}")
    loopy(tail)
  end

  def loopy(empty_list) do
    IO.puts("Lista vazia")
  end
end

Recurse.loopy([1, 2, 3, 4, 5])
