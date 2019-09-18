defmodule Achatdemy.Users.Perm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_perms" do
    field :chmod, :binary
    field :user_id, :id
    field :comm_id, :id

    timestamps()
  end

  @doc false
  def changeset(perm, attrs) do
    perm
    |> cast(attrs, [:chmod])
    |> validate_required([:chmod])
  end
end
