defmodule Achatdemy.Repo.Migrations.CreateMessagesFilesXref do
  use Ecto.Migration

  def change do
    create table(:messages_files_xref) do
      add :message_id, references(:messages, on_delete: :nothing)
      add :file_id, references(:files, on_delete: :nothing)

      timestamps()
    end

    create index(:messages_files_xref, [:message_id])
    create index(:messages_files_xref, [:file_id])
  end
end
