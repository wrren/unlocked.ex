defmodule Unlocked.UserController do
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
		
		render conn, "index.html", user: user, finds: finds, fails: fails
	end

	def show(conn, %{"id" => id} ) do
		case Integer.parse(id) do
			{id, _} when id > 0 ->
				user = Unlocked.Repo.get(Unlocked.User, id)
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
				
				render conn, "index.html", user: user, finds: finds, fails: fails
			_ ->
				conn
				|> put_status(400)
				|> render(Unlocked.ErrorView, :"401", message: "Invalid user ID")
		end
	end

	def search(conn, %{"term" => term}) do
		users = Unlocked.User.search(term) |> Unlocked.User.all
		json conn, users
	end
end