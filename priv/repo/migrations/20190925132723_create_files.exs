defmodule Achatdemy.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :path, :string

      timestamps()
    end

  end
end
