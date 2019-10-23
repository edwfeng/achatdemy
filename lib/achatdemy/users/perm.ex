defmodule Achatdemy.Users.Perm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "user_perms" do
    field :chmod, :integer
    belongs_to :user, Achatdemy.Users.User
    belongs_to :comm, Achatdemy.Comms.Comm

    timestamps()
  end

  @doc false
  def changeset(perm, attrs) do
    perm
    |> cast(attrs, [:chmod])
    |> validate_required([:chmod])
  end
end
