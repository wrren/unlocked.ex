defmodule Unlocked.UserController do
	use Unlocked.Web, :controller

	def index(conn, _params) do
		id = conn.assigns[:current_user].id
		user = Unlocked.Repo.get(Unlocked.User, id) |> Unlocked.User.preload
		render conn, "index.html", user: user		
	end

	def show(conn, %{"id" => id} ) do
		case Integer.parse(id) do
			{id, _} when id > 0 ->
				user = Unlocked.Repo.get(Unlocked.User, id) |> Unlocked.User.preload
				render conn, "index.html", user: user
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