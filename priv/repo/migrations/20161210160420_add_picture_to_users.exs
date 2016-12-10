defmodule Unlocked.Repo.Migrations.AddPictureToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :picture_url, :string
    end
  end
end
