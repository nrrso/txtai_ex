defmodule TxtaiEx.Summary do
  @moduledoc """
  txtai summary instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for summarizing text.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Summarizes a single block of text.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - text: The text to summarize.
  - minlength: The minimum length of the summary (optional).
  - maxlength: The maximum length of the summary (optional).

  ## Returns
  - {:ok, summary_text} on success.
  - {:error, reason} on failure.
  """
  def summary(api, text, minlength \\ nil, maxlength \\ nil) do
    params =
      Enum.into(%{text: text}, %{})
      |> maybe_add_param("minlength", minlength)
      |> maybe_add_param("maxlength", maxlength)

    API.get(api, "summary", params)
    |> handle_response()
  end

  @doc """
  Summarizes a list of texts in batch.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - texts: A list of texts to summarize.
  - minlength: The minimum length of each summary (optional).
  - maxlength: The maximum length of each summary (optional).

  ## Returns
  - {:ok, list_of_summary_texts} on success.
  - {:error, reason} on failure.
  """
  def batchsummary(api, texts, minlength \\ nil, maxlength \\ nil) do
    params =
      Enum.into(%{texts: texts}, %{})
      |> maybe_add_param("minlength", minlength)
      |> maybe_add_param("maxlength", maxlength)

    API.post(api, "batchsummary", params)
    |> handle_response()
  end

  # Private helper functions for adjusting parameters and handling responses
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
