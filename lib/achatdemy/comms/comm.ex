defmodule Achatdemy.Comms.Comm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comms" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(comm, attrs) do
    comm
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
