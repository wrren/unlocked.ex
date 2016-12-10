defmodule Unlocked.Score do
  use Unlocked.Web, :model
  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  schema "scores" do
    field :when, Ecto.DateTime
    belongs_to :scorer, Unlocked.User
    belongs_to :victim, Unlocked.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:when, :scorer_id, :victim_id])
    |> validate_required([:when])
    |> assoc_constraint(:scorer)
    |> assoc_constraint(:victim)
    |> validate_scorer_is_not_victim
    |> validate_score_interval
  end

  defp validate_scorer_is_not_victim(changeset) do
    case {get_field(changeset, :scorer_id), get_field(changeset, :victim_id)} do
      {id, id} ->
        add_error(changeset, :victim_id, "You cannot score against yourself")
      _ ->
        changeset
    end
  end

  defp validate_score_interval(changeset) do
    victim_id = get_field(changeset, :victim_id)
    score_interval = ( Application.get_env(:unlocked, :score_interval) ) * -1
    query = from s in Unlocked.Score,
              where: s.victim_id == ^victim_id,
              where: s.when > from_now(^score_interval, "second"),
            select: s

    case Unlocked.Repo.all(query) do
      [] -> changeset
      _ -> add_error(changeset, :when, "Too many scores against this user in too short a time")
    end
  end

  def create(victim_id, scorer_id) do
    score = %Unlocked.Score{ when: Ecto.DateTime.utc, victim_id: victim_id, scorer_id: scorer_id }
    Unlocked.Repo.insert(changeset(score))
  end

  def by_victim(victim) when is_integer(victim) do
    from s in Unlocked.Score,
    where: s.victim_id == ^victim,
    select: s
  end
  
  def by_victim(victim) do
    from s in Unlocked.Score,
    where: s.victim_id == ^victim.id,
    select: s
  end

  def by_scorer(scorer) when is_integer(scorer) do
    from s in Unlocked.Score,
    where: s.scorer_id == ^scorer,
    select: s
  end

  def by_scorer(scorer) do
    from s in Unlocked.Score,
    where: s.scorer_id == ^scorer.id,
    select: s
  end

  def order_by_date(query, :asc) do
    from s in query, 
    order_by: [asc: :when]
  end

  def order_by_date(query, :desc) do
    from s in query, 
    order_by: [desc: :when]
  end

  def limit(query, limit) do
    from s in query, 
    limit: ^limit
  end

  def all(query) do
    Unlocked.Repo.all query
  end

  def top_scorers() do

  end
end
