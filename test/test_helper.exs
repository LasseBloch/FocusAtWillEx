# Configure mock for Channels.Reader
Mox.defmock(FocusAtWillEx.Channels.MockReader, for: FocusAtWillEx.Channels.Reader)
Application.put_env(:focus_at_will_ex, :channels_reader, FocusAtWillEx.Channels.MockReader)
# Configure mock for Client
Mox.defmock(FocusAtWillEx.MockClient, for: FocusAtWillEx.ClientBehaviour)
Application.put_env(:focus_at_will_ex, :client, FocusAtWillEx.MockClient)

ExUnit.start()
