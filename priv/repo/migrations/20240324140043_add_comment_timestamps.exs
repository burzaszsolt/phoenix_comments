defmodule PhoenixComments.Repo.Migrations.AddCommentTimestamps do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      timestamps()
    end
  end
end
