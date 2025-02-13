defmodule FocusAtWillEx.ClientBehaviour do
  @moduledoc """
  Behaviour definintion for Focus@Will API client
  """

  @type response :: Req.Response.t() | Exception.t()
  @type error :: FocusAtWillEx.Client.Error
  @type session :: FocusAtWillEx.Session.t()
  @type channel :: FocusAtWillEx.Channels.Channel.t()

  @callback authenticate(email :: String.t(), password :: String.t()) :: {:ok, response} | {:error, error}
  @callback fetch_sequence_track(
              session :: session,
              channel :: channel(),
              energy_level :: integer(),
              slot_index :: integer()
            ) ::
              {:ok, response} | {:error, error}
end
