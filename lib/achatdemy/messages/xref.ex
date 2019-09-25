defmodule Achatdemy.Messages.Xref do
  use Ecto.Schema
  import Ecto.Changeset

  schema "msg_files_xref" do
    belongs_to :message_id, Achatdemy.Chats.Message
    belongs_to :file_id, Achatdemy.Messages.File

    timestamps()
  end

  @doc false
  def changeset(xref, attrs) do
    xref
    |> cast(attrs, [])
    |> validate_required([])
  end
end
