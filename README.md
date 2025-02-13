# FocusAtWillEx

**TODO: Add description**

An unofficial API client for Focus@Will.com 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `focus_at_will_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:focus_at_will_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/focus_at_will_ex>.

Client: Raw HTTP communication
Session: Authentication state management
<!--TODO:-->
Player: Business logic for playback
<!--TODO: -->
Config: Configuration management

# Create a session
{:ok, session} = FocusAtWillEx.Session.new(email, password)

# Set a channel
{:ok, channel} = FocusAtWillEx.Channels.get_channel(3104)

# Fetch "track" for channel
{:ok, track} = FocusAtWillEx.Client.fetch_sequence_track(session, channel, 0, 0)

