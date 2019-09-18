defmodule Achatdemy.Chats.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "widgets" do
    field :desc, :string
    field :uri, :string
    field :chat_id, :id

    timestamps()
  end

  @doc false
  def changeset(widget, attrs) do
    widget
    |> cast(attrs, [:uri, :desc])
    |> validate_required([:uri, :desc])
  end
end
