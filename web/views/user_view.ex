defmodule Unlocked.UserView do
	use Unlocked.Web, :view

	def time_format(datetime) do
		seconds = 
			datetime
			|> Ecto.DateTime.to_erl
			|> :calendar.datetime_to_gregorian_seconds
		
		now =
			Ecto.DateTime.utc
			|> Ecto.DateTime.to_erl
			|> :calendar.datetime_to_gregorian_seconds

		difference = now - seconds

		days 				= div difference, (60 * 60 * 24)
		difference 	= difference - (days * (60 * 60 * 24))
		hours 			= div difference, (60 * 60)
		difference 	= difference - (hours * (60 * 60))
		minutes			= div difference, 60
		seconds 		= difference - (minutes * 60)

		case {days, hours, minutes, seconds} do
			{0, 0, 0, 1} 				-> "1 Second Ago"
			{0, 0, 0, seconds} 	-> "#{seconds} Seconds Ago"
			{0, 0, 1, _} 				-> "1 Minute Ago"
			{0, 0, minutes, _} 	-> "#{minutes} Minutes Ago"
			{0, 1, _, _}				-> "1 Hour Ago"
			{0, hours, _, _}		-> "#{hours} Hours Ago"
			{1, _, _, _}				-> "1 Day Ago"
			{days, _, _, _}			-> "#{days} Days Ago"
		end
	end
end