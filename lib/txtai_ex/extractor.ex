defmodule TxtaiEx.Extractor do
  @moduledoc """
  txtai extractor instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for extracting answers to input questions.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Extracts answers to input questions from provided texts.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - queue: A list of maps, each representing a question to be answered. Each map should contain keys: `name`, `query`, `question`, and `snippet`.
  - texts: A list of texts from which the answers should be extracted.

  ## Returns
  - {:ok, answers} on success, where `answers` is a list of maps with keys `name` and `answer`, corresponding to the input questions.
  - {:error, reason} on failure.
  """
  def extract(api, queue, texts) do
    params = %{queue: queue, texts: texts}

    API.post(api, "extract", params)
    |> handle_response()
  end

  # Private helper functions
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Jason.decode!(body)}
  rescue
    _ -> {:error, :invalid_response}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
