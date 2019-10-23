defmodule Achatdemy.Repo.Migrations.CreateComms do
  use Ecto.Migration

  def change do
    create table(:comms, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end

  end
end
