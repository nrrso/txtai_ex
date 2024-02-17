defmodule TxtaiEx.Textractor do
  @moduledoc """
  txtai textractor instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for extracting text from files.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Extracts text from a single file.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - file: The path to the file from which text is to be extracted.

  ## Returns
  - {:ok, extracted_text} on success, where `extracted_text` is the text extracted from the file.
  - {:error, reason} on failure.
  """
  def textract(api, file) do
    params = %{file: file}

    API.get(api, "textract", params)
    |> handle_response()
  end

  @doc """
  Extracts text from a list of files in batch.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - files: A list of paths to files from which text is to be extracted.

  ## Returns
  - {:ok, list_of_extracted_texts} on success, where `list_of_extracted_texts` contains the text extracted from each file.
  - {:error, reason} on failure.
  """
  def batchtextract(api, files) do
    API.post(api, "batchtextract", %{files: files})
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
