defmodule Unlocked.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :when, :datetime
      add :scorer_id, references(:users, on_delete: :nothing)
      add :victim_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:scores, [:scorer_id])
    create index(:scores, [:victim_id])

  end
end
