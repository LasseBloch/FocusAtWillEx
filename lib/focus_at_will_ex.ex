defmodule FocusAtWillEx do
  @moduledoc """
  An unofficial API client for Focusatwill.com.

  This library provides functionality to interact with the Focus@Will API,
  allowing you to manage sessions, browse channels, and fetch tracks.

  ## Basic Usage

      # Create a new session
      {:ok, session} = FocusAtWillEx.session("user@example.com", "password")

      # Get a channel by name or ID
      {:ok, channel} = FocusAtWillEx.get_channel("Chinchilla")
      # or
      {:ok, channel} = FocusAtWillEx.get_channel(3104)

      # Fetch a track
      {:ok, track} = FocusAtWillEx.fetch_sequence_track(session, channel, 0, 0)
  """

  alias FocusAtWillEx.Channels.Channel

  @typedoc """
  A successful result containing the requested data.
  """
  @type ok_result(t) :: {:ok, t}

  @typedoc """
  An error result containing an error message or struct.
  """
  @type error_result :: {:error, String.t() | FocusAtWillEx.Client.Error.t()}

  @doc """
  Creates a new Focus@Will session using your credentials.

  Returns a session struct containing your authentication token and user information.

  ## Security Note
  The session contains your API bearer token. Handle it securely and avoid exposing
  it in logs or sharing it with untrusted parties.

  ## Examples

      {:ok, session} = FocusAtWillEx.session("user@example.com", "password")
      {:error, %FocusAtWillEx.Client.Error{}} = FocusAtWillEx.session("wrong@email.com", "bad_password")

  """
  @spec session(email :: String.t(), password :: String.t()) ::
          ok_result(FocusAtWillEx.Session.t()) | error_result()
  defdelegate session(email, password), to: FocusAtWillEx.Session, as: :new

  @doc """
  Retrieves information about a Focus@Will channel by name or ID.

  ## Examples

      # Get by name
      {:ok, channel} = FocusAtWillEx.get_channel("Chinchilla")

      # Get by ID
      {:ok, channel} = FocusAtWillEx.get_channel(3104)

      # Channel not found
      :error = FocusAtWillEx.get_channel("NonexistentChannel")
  """
  @spec get_channel(name_or_id :: String.t() | integer()) ::
          ok_result(Channel.t()) | :error
  defdelegate get_channel(name_or_id), to: FocusAtWillEx.Channels

  @doc """
  Lists all available Focus@Will channels.

  Returns a map where the keys are channel IDs and values are channel structs.

  ## Examples

      channels = FocusAtWillEx.list_channels()
      Enum.each(channels, fn {id, channel} -> 
        IO.puts("\#{channel.name} (\#{id})")
      end)
  """
  @spec list_channels() :: %{integer() => Channel.t()}
  defdelegate list_channels(), to: FocusAtWillEx.Channels, as: :get_all

  @doc """
  Fetches information about a specific track from a channel.

  ## Parameters
    * `session` - A valid Focus@Will session struct
    * `channel` - The channel struct for which to fetch a track
    * `energy` - Energy level for the track (-1 to 1)
    * `slot` - Index of the track within the channel/energy combination

  ## Examples

      {:ok, session} = FocusAtWillEx.session("user@example.com", "password")
      {:ok, channel} = FocusAtWillEx.get_channel("Chinchilla")
      
      # Get a low-energy track (first slot)
      {:ok, track} = FocusAtWillEx.fetch_sequence_track(session, channel, -1, 0)

      # Get a high-energy track (first slot)
      {:ok, track} = FocusAtWillEx.fetch_sequence_track(session, channel, 1, 0)
  """
  @spec fetch_sequence_track(
          session :: FocusAtWillEx.Session.t(),
          channel :: Channel.t(),
          energy :: integer(),
          slot :: integer()
        ) :: ok_result(map()) | error_result()
  defdelegate fetch_sequence_track(session, channel, energy, slot), to: FocusAtWillEx.Client
end
