defmodule Achatdemy.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :path, :string
      add :message_id, references(:messages, on_delete: :delete_all, type: :uuid), null: false

      timestamps()
    end

  end
end
