defmodule FocusAtWillEx.Channels.Channel do
  @moduledoc false
  defstruct [:name, :id, :description, energy_levels: %{}]

  @type t() :: %__MODULE__{
          name: String.t(),
          id: integer(),
          description: String.t(),
          energy_levels: map()
        }
end
