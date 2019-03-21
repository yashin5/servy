defmodule Servy.Parser do
  alias Servy.Conv

  @spec parse(binary()) :: Servy.Conv.t()
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(params_string)

    %Conv{
      method: method,
      path: path,
      resp_body: "",
      status: nil,
      params: params,
      headers: headers
    }
  end

  @spec parse_params(binary()) :: %{optional(binary()) => binary()}
  def parse_params(params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_headers(header_lines) do
    headers = %{}
  end
end
