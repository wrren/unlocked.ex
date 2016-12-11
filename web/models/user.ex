defmodule Unlocked.User do
  use Unlocked.Web, :model
  import Ecto.Query, only: [from: 2]

  @derive {Poison.Encoder, only: [:id, :name, :picture_url]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :picture_url, :string

    has_many :scores, Unlocked.Score, foreign_key: :scorer_id
    has_many :fails, Unlocked.Score, foreign_key: :victim_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :picture_url])
    |> validate_required([:name, :email, :picture_url])
    |> unique_constraint(:email)
  end

  def find_or_create(email, name, picture_url) do
    case Unlocked.Repo.get_by(Unlocked.User, email: email) do
      nil ->
        Unlocked.Repo.insert(changeset(%Unlocked.User{}, %{email: email, name: name, picture_url: picture_url}))
      user ->
        {:ok, user}
    end
  end

  def find_or_create(auth) do
    find_or_create(auth.info.email, auth.info.name, auth.info.image)
  end

  def search(name_fragment) do
    search = name_fragment |> Kernel.<>("%")
    from u in Unlocked.User, where: like(u.name, ^search), select: u 
  end

  def all(query) do
    Unlocked.Repo.all(query)
  end

  def preload(results) do
    Unlocked.Repo.preload(results, [{:scores, [:scorer, :victim]}, {:fails, [:scorer, :victim]}])
  end
end
