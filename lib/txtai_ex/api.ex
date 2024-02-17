defmodule TxtaiEx.Api do
  @moduledoc """
  Base module for interfacing with a remote txtai service via REST API calls.
  """
  alias TxtaiEx.Api

  defstruct url: System.get_env("TXTAI_API_URL"),
            token: System.get_env("TXTAI_API_TOKEN")

  @doc """
  Initializes a new API struct with the given URL and token.

  ## Parameters
  - url: The base URL of the txtai API.
  - token: The authentication token for the txtai API.

  ## Returns
  - An %API{} struct populated with the base URL and token.
  """
  def new(url \\ nil, token \\ nil) do
    %Api{
      url: url || System.get_env("TXTAI_API_URL"),
      token: token || System.get_env("TXTAI_API_TOKEN")
    }
  end

  @doc """
  Executes a GET request to the specified API method with optional query parameters.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - method: The API method to be called.
  - params: A map of query parameters for the GET request.

  ## Returns
  - {:ok, response} on successful request, where `response` is the JSON-decoded response body.
  - {:error, reason} on failure, with `reason` detailing the error.
  """
  def get(api, method, params \\ %{}) do
    url = build_url(api.url, method, params)
    headers = build_headers(api, %{})

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Executes a POST request to the specified API method with given parameters.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - method: The API method to be called.
  - params: A map or list representing the POST request body.

  ## Returns
  - {:ok, response} on successful request, where `response` is the JSON-decoded response body.
  - {:error, reason} on failure, with `reason` detailing the error.
  """
  def post(api, method, params \\ %{}) do
    url = build_url(api.url, method)
    headers = build_headers(api, %{"Content-Type" => "application/json"})
    body = Jason.encode!(params)

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp build_url(base_url, method, params \\ %{}) do
    query_string = URI.encode_query(params)
    "#{base_url}/#{method}" <> if query_string != "", do: "?#{query_string}", else: ""
  end

  defp build_headers(%Api{token: token}, base_headers) do
    base_headers
    |> Map.put_new("Authorization", "Bearer #{token}")
    |> Enum.filter(fn {_, v} -> v != nil end)
  end
end
