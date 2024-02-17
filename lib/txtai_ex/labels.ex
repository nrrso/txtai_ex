defmodule TxtaiEx.Labels do
  @moduledoc """
  txtai labels instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for applying zero-shot classification to text.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Applies zero-shot classification to a given text using a provided list of labels.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - text: The text to classify.
  - labels: A list of labels for classification.

  ## Returns
  - {:ok, classifications} on success, where `classifications` is a list of maps with keys `id` and `score`, sorted by highest score.
  - {:error, reason} on failure.
  """
  def label(api, text, labels) do
    params = %{text: text, labels: labels}

    API.post(api, "label", params)
    |> handle_response()
  end

  @doc """
  Applies zero-shot classification in batch mode to a list of texts using a provided list of labels.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - texts: A list of texts to classify.
  - labels: A list of labels for classification.

  ## Returns
  - {:ok, batch_classifications} on success, where `batch_classifications` contains a list of classification results for each text.
  - {:error, reason} on failure.
  """
  def batchlabel(api, texts, labels) do
    params = %{texts: texts, labels: labels}

    API.post(api, "batchlabel", params)
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
