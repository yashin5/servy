defmodule Servy.Plugins do

  alias Servy.Conv

  @spec track(any()) :: any()
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  @spec rewrite_path(any()) :: any()
  def rewrite_path(%Conv{path: "/wilflife"} = conv) do
    %{conv | path: "wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  @spec log(any()) :: any()
  def log(%Conv{} = conv), do: IO.inspect(conv)

end
