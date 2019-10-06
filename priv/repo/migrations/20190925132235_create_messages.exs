defmodule Achatdemy.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :msg, :text
      add :chat_id, references(:chats, on_delete: :nothing, type: :uuid)
      add :author_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:messages, [:chat_id])
    create index(:messages, [:author_id])
  end
end
