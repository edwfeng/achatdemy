defmodule Achatdemy.Repo.Migrations.ChangeMessagesAuthorIdFkey do
  use Ecto.Migration

  def change do
    drop constraint(:messages, "messages_author_id_fkey")
    alter table(:messages) do
      modify :author_id, references(:users, on_delete: :nothing)
    end
  end
end
