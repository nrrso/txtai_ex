defmodule TxtaiEx.Segmentation do
  @moduledoc """
  txtai segmentation instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for segmenting text into semantic units.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Segments text into semantic units.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - text: The text to segment.

  ## Returns
  - {:ok, segments} on success, where `segments` is a list of segmented text units.
  - {:error, reason} on failure.
  """
  def segment(api, text) do
    params = %{text: text}

    API.get(api, "segment", params)
    |> handle_response()
  end

  @doc """
  Segments a list of texts into semantic units in batch.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - texts: A list of texts to be segmented.

  ## Returns
  - {:ok, batch_segments} on success, where `batch_segments` is a list of lists, each containing segmented text units for each input text.
  - {:error, reason} on failure.
  """
  def batchsegment(api, texts) do
    API.post(api, "batchsegment", texts)
    |> handle_response()
  end

  # Private helper functions for handling HTTP responses
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Jason.decode!(body)}
  rescue
    _ -> {:error, :invalid_response}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
