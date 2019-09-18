defmodule Achatdemy.Repo.Migrations.SwitchToText do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      modify :title, :text
    end

    alter table(:messages) do
      modify :msg, :text
    end

    alter table(:widgets) do
      modify :desc, :text
    end
  end
end
