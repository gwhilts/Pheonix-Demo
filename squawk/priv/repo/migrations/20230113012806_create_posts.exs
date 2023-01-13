defmodule Squawk.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :username, :string
      add :body, :string
      add :likes, :integer

      timestamps()
    end
  end
end
