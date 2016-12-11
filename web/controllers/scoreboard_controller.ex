defmodule Unlocked.ScoreboardController do
	use Unlocked.Web, :controller

	def recent(conn, _params) do
		recent = Unlocked.Score
			|> Unlocked.Score.order_by_date(:desc)
			|> Unlocked.Score.limit(50)
			|> Unlocked.Score.all
			|> Unlocked.Score.preload
		
		render conn, "recent.html", list: recent
	end

	def top(conn, %{"interval" => days}) do
		case Integer.parse(days) do
			{days, _} when days > 0 ->
				finders = Unlocked.Score.top_finders(days) |> Unlocked.Score.all
				failers = Unlocked.Score.top_failers(days) |> Unlocked.Score.all
				render conn, "top.html", finders: finders, failers: failers, interval: days
			_ ->
				conn
				|> put_status(400)
				|> render(Unlocked.ErrorView, :"401", message: "Invalid Interval")
		end
	end

	def top(conn, _params) do
		finders = Unlocked.Score.top_finders() |> Unlocked.Score.all
		failers = Unlocked.Score.top_failers() |> Unlocked.Score.all
		render conn, "top.html", finders: finders, failers: failers
	end

end