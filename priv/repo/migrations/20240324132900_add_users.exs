defmodule PhoenixComments.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :url, :string
      add :name, :string
      add :provider, :string
      add :token, :string
      add :profile_image, :string

      timestamps()
    end
  end
end
