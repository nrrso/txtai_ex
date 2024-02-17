defmodule TxtaiEx.Workflow do
  @moduledoc """
  txtai workflow instance for interfacing with a remote txtai service via REST API calls,
  providing functionality for executing named workflows with specified elements.
  """

  alias TxtaiEx.Api, as: API

  @doc """
  Executes a named workflow using elements as input.

  ## Parameters
  - api: The API struct containing configuration for URL and token.
  - name: The name of the workflow to execute.
  - elements: A list of elements (e.g., texts, images) to process through the workflow.

  ## Returns
  - {:ok, processed_elements} on success, where `processed_elements` is a list of elements processed by the workflow.
  - {:error, reason} on failure.
  """
  def workflow(api, name, elements) do
    params = %{name: name, elements: elements}

    API.post(api, "workflow", params)
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
