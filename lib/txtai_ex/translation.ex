defmodule TxtaiEx.Translation do
  @moduledoc """
  txtai translation instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for translating text between languages.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Translates a single text from the source language to the target language.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - text: The text to translate.
  - target: The target language code (defaults to "en").
  - source: The source language code (optional, auto-detects if not provided).

  ## Returns
  - {:ok, translated_text} on success.
  - {:error, reason} on failure.
  """
  def translate(api, text, target \\ "en", source \\ nil) do
    params =
      Enum.into(%{text: text}, %{})
      |> maybe_add_param("target", target)
      |> maybe_add_param("source", source)

    API.get(api, "translate", params)
    |> handle_response()
  end

  @doc """
  Translates a list of texts from the source language to the target language in batch.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - texts: A list of texts to translate.
  - target: The target language code (defaults to "en").
  - source: The source language code (optional, auto-detects if not provided).

  ## Returns
  - {:ok, list_of_translated_texts} on success.
  - {:error, reason} on failure.
  """
  def batchtranslate(api, texts, target \\ "en", source \\ nil) do
    params =
      Enum.into(%{texts: texts}, %{})
      |> maybe_add_param("target", target)
      |> maybe_add_param("source", source)

    # Ensure correction for the mistake in original JS code where `files` should be `params`
    API.post(api, "batchtranslate", params)
    |> handle_response()
  end

  # Private helper functions for adjusting parameters and handling responses
  defp maybe_add_param(params, key, value) when not is_nil(value) and value != "" do
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
