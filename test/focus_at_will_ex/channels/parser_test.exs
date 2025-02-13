defmodule FocusAtWillEx.Channels.ParserTest do
  alias FocusAtWillEx.Channels.Parser
  use ExUnit.Case, async: true

  test "happy part" do
    string =
      """
      [
      {
        "id": 3154,
        "artistName": "",
        "artistSiteUrl": "",
        "description": "Nostalgic, ambient jungle. Old school meets new school. Exclusive new channel.",
        "name": "Jambient Jungle",
        "energyLevelLabels": [
            "Slower",
            "Classic",
            "Xtra"
        ],
        "fadeIn": 2800,
        "fadeOut": 2000,
        "fadeOverlap": 2300,
        "isWip": false,
        "artistImageUrl": "https://cdn-images.focusatwill.com/channel_icons/default_artist.svg",
        "backgroundImageUrl": "https://cdn-images.focusatwill.com/channel_icons/production/3154/2b6e5446-d70d-4cbf-9ae9-e9703c72d61f.png",
        "desktopBackgroundImageUrl": "https://cdn-images.focusatwill.com/channel_icons/production/3154/ab8fe884-8b33-429c-a639-d34c1adeb8ff.png",
        "iconUrl": "https://cdn-images.focusatwill.com/channel_icons/default_channel.svg"
      }
      ]
      """

    expected = %{
      3154 => %FocusAtWillEx.Channels.Channel{
        name: "Jambient Jungle",
        description:
          "Nostalgic, ambient jungle. Old school meets new school. Exclusive new channel.",
        energy_levels: %{1 => "Slower", 2 => "Classic", 3 => "Xtra"}
      }
    }

    assert Parser.parse_json(string) == expected
  end
end
