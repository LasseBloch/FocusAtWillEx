defmodule FocusAtWillEx.Channels.ChannelsTest do
  use ExUnit.Case, async: true

  import Mox

  alias FocusAtWillEx.Channels
  alias FocusAtWillEx.Channels.MockReader

  setup :verify_on_exit!

  setup do
    mock_channels = %{
      1 => %{name: "Test Channel 1", type: "focus"},
      2 => %{name: "Test Channel 2", type: "energy"}
    }

    {:ok, channels: mock_channels}
  end

  describe "get_channel/1" do
    test "returns channel by id", %{channels: mock_channels} do
      expect(MockReader, :read_channels, 2, fn -> mock_channels end)

      assert Channels.get_channel(1) == {:ok, mock_channels[1]}
      assert Channels.get_channel(14) == :error
    end

    test "returns channel by name", %{channels: mock_channels} do
      expect(MockReader, :read_channels, 3, fn -> mock_channels end)

      assert Channels.get_channel("Test Channel 1") == {:ok, mock_channels[1]}
      assert Channels.get_channel("nonexistent") == :error
    end

    test "handles empty channel list" do
      expect(MockReader, :read_channels, fn -> %{} end)
      assert Channels.get_channel(1) == :error
    end
  end

  describe "get_channel!/1" do
    test "raises for non-existent id", %{channels: mock_channels} do
      expect(MockReader, :read_channels, fn -> mock_channels end)

      assert_raise KeyError, "Channel with ID 3 not found", fn ->
        Channels.get_channel!(3)
      end
    end

    test "raises for non-existent name", %{channels: mock_channels} do
      expect(MockReader, :read_channels, fn -> mock_channels end)

      assert_raise KeyError, "Channel with name Fancy foke not found", fn ->
        Channels.get_channel!("Fancy foke")
      end
    end

    test "returns channel for valid id", %{channels: mock_channels} do
      expect(MockReader, :read_channels, fn -> mock_channels end)
      assert Channels.get_channel!(1) == mock_channels[1]
    end
  end

  describe "list_names/0" do
    test "returns all channel names", %{channels: mock_channels} do
      expect(MockReader, :read_channels, fn -> mock_channels end)

      expected_names = ["Test Channel 1", "Test Channel 2"]
      assert Enum.sort(Channels.list_names()) == Enum.sort(expected_names)
    end

    test "returns empty list for empty channels" do
      expect(MockReader, :read_channels, fn -> %{} end)
      assert Channels.list_names() == []
    end
  end

  describe "get_all/0" do
    test "returns all channels", %{channels: mock_channels} do
      expect(MockReader, :read_channels, fn -> mock_channels end)
      assert Channels.get_all() == mock_channels
    end
  end
end
