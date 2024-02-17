defmodule TxtaiEx.Embeddings do
  @moduledoc """
  Handles interactions with a remote txtai embeddings service, offering functionalities such as
  searching for similar documents, adding documents for indexing, and more, via REST API calls.
  """
  alias TxtaiEx.Api, as: API

  defstruct [:url, :token]

  @doc """
  Searches for documents similar to the input query within the embeddings model.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - query: Text query to search for similar documents.
  - limit: Maximum number of results to return (default: 10).
  - weights: (Optional) Hybrid score weights for adjusting importance in scoring.
  - index: (Optional) Specific index name to search within.

  ## Returns
  - {:ok, results} on success, with `results` being a list of documents sorted by similarity score.
  - {:error, reason} on failure.
  """
  def search(api, query, limit \\ 10, weights \\ nil, index \\ nil) do
    params =
      Enum.into([query: query, limit: limit], %{})
      |> maybe_add_param("weights", weights)
      |> maybe_add_param("index", index)

    API.get(api, "search", params)
    |> handle_response()
  end

  @doc """
  Performs a batch search for queries, finding documents similar to each query.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - queries: List of text queries to search for similar documents.
  - limit: Maximum number of results per query (default: 10).
  - weights: (Optional) Hybrid score weights.
  - index: (Optional) Specific index name to search within.

  ## Returns
  - {:ok, results} on success, with `results` being a list of results per query.
  - {:error, reason} on failure.
  """
  def batchsearch(api, queries, limit \\ 10, weights \\ nil, index \\ nil) do
    params =
      Enum.into([queries: queries, limit: limit], %{})
      |> maybe_add_param("weights", weights)
      |> maybe_add_param("index", index)

    API.post(api, "batchsearch", params)
    |> handle_response()
  end

  @doc """
  Adds a batch of documents for indexing in the embeddings model.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - documents: List of documents, where each is a map with `id` and `text` keys.

  ## Returns
  - {:ok, response} on successful indexing.
  - {:error, reason} on failure.
  """
  def add(api, documents) do
    API.post(api, "add", documents)
    |> handle_response()
  end

  @doc """
  Triggers indexing of previously added documents.

  ## Parameters
  - api: Struct containing API configuration (URL and token).

  ## Returns
  - {:ok, response} upon successful triggering of the indexing process.
  - {:error, reason} on failure.
  """
  def index(api) do
    API.get(api, "index", %{})
    |> handle_response()
  end

  @doc """
  Updates or inserts documents into the embeddings index, depending on whether they exist.

  ## Parameters
  - api: Struct containing API configuration (URL and token).

  ## Returns
  - {:ok, response} upon successful upsert operation.
  - {:error, reason} on failure.
  """
  def upsert(api) do
    API.get(api, "upsert", %{})
    |> handle_response()
  end

  @doc """
  Deletes specified documents from the embeddings index.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - ids: List of document ids to delete.

  ## Returns
  - {:ok, response} upon successful deletion.
  - {:error, reason} on failure.
  """
  def delete(api, ids) do
    API.post(api, "delete", ids)
    |> handle_response()
  end

  @doc """
  Recreates the embeddings index with new configuration settings.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - config: New configuration settings for the index.
  - func: (Optional) A function to prepare content for indexing.

  ## Returns
  - {:ok, response} upon successful reindexing.
  - {:error, reason} on failure.
  """
  def reindex(api, config, func \\ nil) do
    params =
      Enum.into([config: config], %{})
      |> maybe_add_param("function", func)

    API.post(api, "reindex", params)
    |> handle_response()
  end

  @doc """
  Counts the total number of documents in the embeddings index.

  ## Parameters
  - api: Struct containing API configuration (URL and token).

  ## Returns
  - {:ok, count} with `count` being the total number of documents in the index.
  - {:error, reason} on failure.
  """
  def count(api) do
    API.get(api, "count", %{})
    |> handle_response()
  end

  @doc """
  Computes similarity between a query and a list of texts.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - query: The query text.
  - texts: A list of texts to compare against the query.

  ## Returns
  - {:ok, scores} on success, where `scores` is a list of similarity scores.
  - {:error, reason} on failure.
  """
  def similarity(api, query, texts) do
    API.post(api, "similarity", %{query: query, texts: texts})
    |> handle_response()
  end

  @doc """
  Computes similarity between a list of queries and a list of texts in batch.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - queries: A list of query texts.
  - texts: A list of texts to compare against each query.

  ## Returns
  - {:ok, scores} on success, with `scores` being a list of results for each query.
  - {:error, reason} on failure.
  """
  def batchsimilarity(api, queries, texts) do
    API.post(api, "batchsimilarity", %{queries: queries, texts: texts})
    |> handle_response()
  end

  @doc """
  Transforms text into embeddings representation.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - text: The text to transform.

  ## Returns
  - {:ok, embeddings} on success, where `embeddings` is the embeddings representation of the text.
  - {:error, reason} on failure.
  """
  def transform(api, text) do
    API.get(api, "transform", %{text: text})
    |> handle_response()
  end

  @doc """
  Transforms a list of texts into embeddings representations in batch.

  ## Parameters
  - api: Struct containing API configuration (URL and token).
  - texts: A list of texts to transform.

  ## Returns
  - {:ok, embeddings} on success, where `embeddings` is a list of embeddings representations for each text.
  - {:error, reason} on failure.
  """
  def batchtransform(api, texts) do
    API.post(api, "batchtransform", texts)
    |> handle_response()
  end

  # Private helper functions
  defp maybe_add_param(params, key, value) when not is_nil(value) do
    Map.put(params, key, value)
  end

  defp maybe_add_param(params, _, _) do
    params
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Jason.decode!(body)}
  rescue
    _ -> {:error, :invalid_response}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
