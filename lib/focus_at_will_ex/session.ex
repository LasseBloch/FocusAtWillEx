defmodule FocusAtWillEx.Session do
  @moduledoc """
  Information about Focus@Will API session
  """
  alias FocusAtWillEx.Client

  defp client, do: Application.get_env(:focus_at_will_ex, :client, FocusAtWillEx.Client)

  defstruct [:token, :user]

  @type t() :: %__MODULE__{
          token: String.t(),
          user: map
        }

  @spec new(String.t(), String.t()) :: {:ok, t()} | {:error, Client.Error} | {:error, String.t()}
  def new(email, password) do
    case authenticate(email, password) do
      {:ok, {token, user}} -> %__MODULE__{token: token, user: user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp authenticate(email, password) do
    with {:ok, body} <- client().authenticate(email, password) do
      parse_response(body)
    end
  end

  defp parse_response(response) do
    with {:ok, token} <- Map.fetch(response, "authentication_token"),
         {:ok, user} <- Map.fetch(response, "user") do
      {:ok, {token, user}}
    else
      :error -> {:error, "Invalid response format: missing authentication_token or user"}
    end
  end
end
