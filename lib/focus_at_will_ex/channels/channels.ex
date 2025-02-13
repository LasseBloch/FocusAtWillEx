defmodule FocusAtWillEx.Channels do
  @moduledoc false

  alias FocusAtWillEx.Channels.Channel

  defp reader_imp, do: Application.get_env(:focus_at_will_ex, :channels_reader, FocusAtWillEx.Channels.FileReader)

  defp channels do
    reader_imp().read_channels()
  end

  defp name_to_id do
    Map.new(channels(), fn {id, channel} -> {channel.name, id} end)
  end

  @spec get_channel!(integer | String.t()) :: {:ok, Channel.t()} | :error
  def get_channel(id) when is_integer(id) do
    Map.fetch(channels(), id)
  end

  def get_channel(name) when is_binary(name) do
    id = Map.fetch(name_to_id(), name)

    case id do
      {:ok, id} -> get_channel(id)
      :error -> :error
    end
  end

  @spec get_channel!(integer | String.t()) :: Channel.t() | no_return
  def get_channel!(id) when is_integer(id) do
    case get_channel(id) do
      {:ok, channel} -> channel
      :error -> raise(KeyError, "Channel with ID #{id} not found")
    end
  end

  def get_channel!(name) when is_binary(name) do
    case get_channel(name) do
      {:ok, channel} -> channel
      :error -> raise(KeyError, "Channel with name #{name} not found")
    end
  end

  @spec get_all() :: map
  def get_all, do: channels()

  @spec list_names() :: [binary]
  def list_names, do: Enum.map(channels(), fn {_id, channel} -> channel.name end)
end
