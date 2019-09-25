defmodule Achatdemy.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :msg, :text
      add :chat_id, references(:chats, on_delete: :nothing)
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:chat_id])
    create index(:messages, [:author_id])
  end
end
