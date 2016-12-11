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
    |> validate_required([:when, :victim_id, :scorer_id])
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
    if is_nil(victim_id) do
      add_error changeset, :victim_id, "Must specify a person to score against"
    else
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

  def preload(results) do
    Unlocked.Repo.preload(results, [:scorer, :victim])
  end

  def top_finders(interval) do
    interval = interval * -1
    from s in Unlocked.Score,
      join: u in Unlocked.User, on: s.scorer_id == u.id,
    where: s.when >= from_now(^interval, "day"),
    select: %{scorer: u, count: count(s.id)},
    group_by: s.scorer_id,
    having: count(s.id) > 0,
    order_by: [desc: count(s.id)]
  end

  def top_finders() do
    from s in Unlocked.Score,
      join: u in Unlocked.User, on: s.scorer_id == u.id,
    select: %{scorer: u, count: count(s.id)},
    group_by: s.scorer_id,
    having: count(s.id) > 0,
    order_by: [desc: count(s.id)]
  end

  def top_failers(interval) do
    interval = interval * -1
    from s in Unlocked.Score,
      join: u in Unlocked.User, on: s.victim_id == u.id,
    where: s.when >= from_now(^interval, "day"),
    select: %{victim: u, count: count(s.id)},
    group_by: s.victim_id,
    having: count(s.id) > 0,
    order_by: [desc: count(s.id)]
  end

  def top_failers() do
    from s in Unlocked.Score,
      join: u in Unlocked.User, on: s.victim_id == u.id,
    select: %{victim: u, count: count(s.id)},
    group_by: s.victim_id,
    having: count(s.id) > 0,
    order_by: [desc: count(s.id)]
  end
end
