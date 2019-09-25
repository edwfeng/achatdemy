defmodule Achatdemy.Repo.Migrations.CreateMsgFilesXref do
  use Ecto.Migration

  def change do
    create table(:msg_files_xref) do
      add :message_id, references(:messages, on_delete: :nothing)
      add :file_id, references(:files, on_delete: :nothing)

      timestamps()
    end

    create index(:msg_files_xref, [:message_id])
    create index(:msg_files_xref, [:file_id])
  end
end
