defmodule FocusAtWillEx.Channels.Parser do
  alias FocusAtWillEx.Channels.Channel

  @moduledoc """
  Deserialize a JSON string to a Channel sruct
  """

  @doc ~S"""
  Create channel structs from a string
  """
  def parse_json(json_string) do
    json_string
    |> Jason.decode!()
    |> Enum.reduce(%{}, &process_channel/2)
  end

  defp process_channel(channel_data, acc) do
    # Extract the needed fields from the JSON data
    %{
      "id" => id,
      "name" => name,
      "description" => description,
      "energyLevelLabels" => energy_labels
    } = channel_data

    # Create Channel struct with transformed data
    channel = %Channel{
      name: name,
      description: description,
      energy_levels: create_energy_levels_map(energy_labels)
    }

    # Add to accumulator map with ID as key
    Map.put(acc, id, channel)
  end

  defp create_energy_levels_map(labels) do
    labels
    |> Enum.with_index(1)
    |> Map.new(fn {label, index} -> {index, label} end)
  end
end
