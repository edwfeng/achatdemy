defmodule Achatdemy.Repo.Migrations.CreateMsgFilesXref do
  use Ecto.Migration

  def change do
    create table(:msg_files_xref, primary_key: false) do
      add :message_id, references(:messages, on_delete: :delete_all, type: :uuid), primary_key: true
      add :file_id, references(:files, on_delete: :delete_all, type: :uuid), primary_key: true
    end

    create index(:msg_files_xref, [:message_id])
    create index(:msg_files_xref, [:file_id])
  end
end
