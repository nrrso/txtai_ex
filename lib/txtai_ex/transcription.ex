defmodule TxtaiEx.Transcription do
  @moduledoc """
  txtai transcription instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for transcribing audio files to text.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Transcribes audio from a single file to text.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - file: The path to the audio file to be transcribed.

  ## Returns
  - {:ok, transcription} on success, where `transcription` is the text transcribed from the audio file.
  - {:error, reason} on failure.
  """
  def transcribe(api, file) do
    params = %{file: file}

    API.get(api, "transcribe", params)
    |> handle_response()
  end

  @doc """
  Transcribes audio from a list of files to text in batch.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - files: A list of paths to audio files to be transcribed.

  ## Returns
  - {:ok, transcriptions} on success, where `transcriptions` is a list of texts transcribed from each audio file.
  - {:error, reason} on failure.
  """
  def batchtranscribe(api, files) do
    API.post(api, "batchtranscribe", %{files: files})
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
