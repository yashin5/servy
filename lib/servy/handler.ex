defmodule Servy.Handler do
  @moduledoc "Hadles HTTP request."

  alias Servy.Conv
  alias Servy.Parser
  alias Servy.Plugins

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transform the request into a response."
  @spec handle(binary()) :: <<_::64, _::_*8>>

  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> Plugins.log()
    |> route()
    |> Plugins.track()
    |> format_response()
  end

  @spec route(Servy.Conv.t()) :: Servy.Conv.t()
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    %{
      conv
      | status: 201,
        resp_body: "Create a #{conv.params["type"]} bear named #{conv.params["name"]}!"
    }
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  @spec handle_file({:error, any()} | {:ok, any()}, Servy.Conv.t()) :: Servy.Conv.t()
  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, _enoent}, %Conv{} = conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  @spec format_response(atom() | %{resp_body: binary(), status: any()}) :: <<_::64, _::_*8>>
  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
POST /bears HTTP:/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length:21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts(response)
