defmodule Unlocked.PageController do
  use Unlocked.Web, :controller

  def index(conn, _params) do
    user = Unlocked.Repo.get(Unlocked.User, conn.assigns[:current_user].id) |> Unlocked.User.preload
		changeset = Unlocked.Score.changeset(%Unlocked.Score{})
		render conn, "index.html", user: user, changeset: changeset
  end

  def score(conn, %{"scorer_id" => id}) do
		user = Unlocked.Repo.get(Unlocked.User, conn.assigns[:current_user].id) |> Unlocked.User.preload

    {id, _} = Integer.parse(id)
    case Unlocked.Score.create(conn.assigns[:current_user].id, id) do
      {:ok, score} -> 
        changeset = Unlocked.Score.changeset(%Unlocked.Score{})
        render conn, "index.html", user: user, changeset: changeset
      {:error, changeset} ->
        if changeset.errors[:victim_id] do
          conn
          |> put_flash(:error, :erlang.element(1, changeset.errors[:victim_id]))
          |> render "index.html", user: user, changeset: changeset
        else
          conn
          |> render "index.html", user: user, changeset: changeset
        end
    end 
  end
end
