defmodule Achatdemy.Messages.MsgFilesXref do
  use Ecto.Schema
  alias Achatdemy.Messages

  @primary_key false
  @foreign_key_type :binary_id
  schema "msg_files_xref" do
    belongs_to :message, Messages.Message
    belongs_to :file, Messages.File
  end
end
