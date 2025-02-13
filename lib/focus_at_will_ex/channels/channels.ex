alias FocusAtWillEx.Channels.Parser

defmodule FocusAtWillEx.Channels do
  @moduledoc false
  @external_resource "priv/channels.json"
  @channels @external_resource
            |> File.read!()
            |> Parser.parse_json()

  @name_to_id Map.new(@channels, fn {id, channel} -> {channel.name, id} end)

  def get_channel(id) when is_integer(id) do
    Map.fetch(@channels, id)
  end

  def get_channel(name) when is_binary(name) do
    Map.fetch(@name_to_id, name)
  end

  def get_channel!(id) when is_integer(id) do
    case get_channel(id) do
      {:ok, channel} -> channel
      :error -> raise(KeyError)
    end
  end

  def get_channel!(name) when is_binary(name) do
    case get_channel(name) do
      {:ok, channel} -> channel
      :error -> raise(KeyError)
    end
  end

  def get_all, do: @channels
  def list_names, do: Enum.map(@channels, fn {_id, channel} -> channel.name end)
end
