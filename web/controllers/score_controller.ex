defmodule Unlocked.ScoreController do
	use Unlocked.Web, :controller
	plug Ueberauth

	def index(conn, _params) do
    changeset = Unlocked.Score.changeset(%Unlocked.Score{})
		render(conn, "index.html", changeset: changeset)
	end

  def score(conn, %{"scorer_id" => id}) do
    {id, _} = Integer.parse(id)
    case Unlocked.Score.create(conn.assigns[:current_user].id, id) do
      {:ok, score} -> 
        render conn, "success.html", score: Unlocked.Score.preload(score)
      {:error, changeset} ->
        render conn, "index.html", changeset: changeset
    end 
  end
end