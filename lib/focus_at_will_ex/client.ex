defmodule FocusAtWillEx.Client do
  @moduledoc """
  HTTP Client for Focus@Will API interactions
  """
  @behaviour FocusAtWillEx.ClientBehaviour

  alias FocusAtWillEx.Channels.Channel
  alias FocusAtWillEx.Session

  @base_url "https://api.focusatwill.com/api/v4"

  defmodule Error do
    @moduledoc false

    @type t() :: %__MODULE__{
            message: String.t(),
            response: Req.Response.t() | Exception.t()
          }

    defexception [:message, :response]

    @spec new(String.t(), Req.Response.t() | Exception.t()) :: t()
    def new(message, response) do
      %__MODULE__{message: message, response: response}
    end
  end

  def new(opts \\ []) do
    [base_url: @base_url]
    |> Req.new()
    |> Req.merge(opts)
  end

  @impl true
  @spec authenticate(String.t(), String.t()) :: {:ok, Req.Response.t()} | {:error, Error.t()}
  def authenticate(email, password) do
    new()
    |> Req.post(url: "/sign_in.json", json: %{user: %{email: email, password: password}})
    |> handle_response()
  end

  @doc """
  Fetch track number: slot_index from channel: channel with energy_level: level
  """
  @impl true
  @spec fetch_sequence_track(Session.t(), Channel.t(), integer(), integer()) ::
          {:ok, Req.Response.t()} | {:error, Error.t()}
  def fetch_sequence_track(%Session{token: token}, channel, energy_level, slot_index) do
    request_body =
      %{
        energy_level: energy_level,
        track_user_genre_id: Integer.to_string(channel.id),
        track_index: %{slot_index: slot_index, seqeunce_loop: 1},
        rate_limiter_total: 1,
        auth_token: token
      }

    new()
    |> Req.post(url: "/fetch_sequence_track.json", json: request_body)
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}) when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, response}) do
    {:error, Error.new("Request failed", response)}
  end

  defp handle_response({:error, exception}) do
    {:error, Error.new("Request failed", exception)}
  end
end
