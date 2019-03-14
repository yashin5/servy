defmodule Servy.Handler do
  @spec handle(any()) :: nil
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  @spec parse(any()) :: %{method: <<_::24>>, path: <<_::88>>, resp_body: <<>>}
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  @spec route(any()) :: %{method: <<_::24>>, path: <<_::88>>, resp_body: <<_::160>>}
  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{conv | resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bearanimal") do
    %{conv | resp_body: "Teddy, Loly, Tiny"}
  end

  @spec format_response(any()) :: <<_::712>>
  def format_response(conv) do
    """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: #{String.length(conv.resp_body)}

      #{conv.resp_body}
    """
  end
end
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agente: ExampleBrowser/1.0
Accept: */*

"""



response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bearanimal HTTP/1.1
Host: example.com
User-Agente: ExampleBrowser/1.0
Accept: */*

"""



response = Servy.Handler.handle(request)

IO.puts response
