defmodule TxtaiEx.Similarity do
  @moduledoc """
  txtai similarity instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for computing similarities between texts.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Computes the similarity between a query and a list of texts.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - query: The query text.
  - texts: A list of texts to compare against the query for similarity.

  ## Returns
  - {:ok, similarity_scores} on success, where `similarity_scores` is a list of {id, score} tuples sorted by highest score.
  - {:error, reason} on failure.
  """
  def similarity(api, query, texts) do
    params = %{query: query, texts: texts}

    API.post(api, "similarity", params)
    |> handle_response()
  end

  @doc """
  Computes the similarity between a list of queries and a list of texts in batch.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - queries: A list of query texts.
  - texts: A list of texts to compare against each query for similarity.

  ## Returns
  - {:ok, batch_similarity_scores} on success, with results for each query.
  - {:error, reason} on failure.
  """
  def batchsimilarity(api, queries, texts) do
    params = %{queries: queries, texts: texts}

    API.post(api, "batchsimilarity", params)
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
