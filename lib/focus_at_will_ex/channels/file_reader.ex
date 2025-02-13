defmodule FocusAtWillEx.Channels.FileReader do
  @moduledoc false
  @behaviour FocusAtWillEx.Channels.Reader

  alias FocusAtWillEx.Channels.Parser

  def read_channels do
    "priv/channels.json"
    |> File.read!()
    |> Parser.parse_json()
  end
end
