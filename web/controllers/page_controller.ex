defmodule Unlocked.PageController do
  use Unlocked.Web, :controller

  def index(conn, _params) do
    user = conn.assigns[:current_user]
		finds = Unlocked.Score.by_scorer(user.id)
						|> Unlocked.Score.order_by_date(:desc)
						|> Unlocked.Score.limit(10)
						|> Unlocked.Score.all
						|> Unlocked.Score.preload

		fails = Unlocked.Score.by_victim(user.id)
						|> Unlocked.Score.order_by_date(:desc)
						|> Unlocked.Score.limit(10)
						|> Unlocked.Score.all
						|> Unlocked.Score.preload
		changeset = Unlocked.Score.changeset(%Unlocked.Score{})
		render conn, "index.html", user: user, finds: finds, fails: fails, changeset: changeset
  end

  def index(conn, _params) do
    changeset = Unlocked.Score.changeset(%Unlocked.Score{})
		render(conn, "index.html", changeset: changeset)
	end

  def score(conn, %{"scorer_id" => id}) do
    user = conn.assigns[:current_user]
		finds = Unlocked.Score.by_scorer(user.id)
						|> Unlocked.Score.order_by_date(:desc)
						|> Unlocked.Score.limit(10)
						|> Unlocked.Score.all
						|> Unlocked.Score.preload

		fails = Unlocked.Score.by_victim(user.id)
						|> Unlocked.Score.order_by_date(:desc)
						|> Unlocked.Score.limit(10)
						|> Unlocked.Score.all
						|> Unlocked.Score.preload

    {id, _} = Integer.parse(id)
    case Unlocked.Score.create(conn.assigns[:current_user].id, id) do
      {:ok, score} -> 
        changeset = Unlocked.Score.changeset(%Unlocked.Score{})
        render conn, "index.html", user: user, finds: finds, fails: fails, changeset: changeset
      {:error, changeset} ->
        if changeset.errors[:victim_id] do
          conn
          |> put_flash(:error, :erlang.element(1, changeset.errors[:victim_id]))
          |> render "index.html", user: user, finds: finds, fails: fails, changeset: changeset
        else
          conn
          |> render "index.html", user: user, finds: finds, fails: fails, changeset: changeset
        end
    end 
  end
end
