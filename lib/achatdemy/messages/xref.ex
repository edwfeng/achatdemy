defmodule Achatdemy.Messages.Xref do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages_files_xref" do
    field :message_id, :id
    field :file_id, :id

    timestamps()
  end

  @doc false
  def changeset(xref, attrs) do
    xref
    |> cast(attrs, [])
    |> validate_required([])
  end
end
