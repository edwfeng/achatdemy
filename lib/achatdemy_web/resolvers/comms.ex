defmodule AchatdemyWeb.Resolvers.Comms do
  alias Achatdemy.Comms

  def list_comms(_, _, _) do
    {:ok, Comms.list_comms()}
  end

  def list_comm(_, %{id: id}, _) do
    {:ok, Comms.get_comm!(id)}
  end
end
