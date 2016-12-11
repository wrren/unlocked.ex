defmodule Unlocked.Plug.Authenticate do
	import Plug.Conn

	def init(opts), do: opts

	def call(conn, %{ :path => path, :redirect => redirect}) do
		request_path = conn.request_path

		case get_session(conn, :current_user) do
			nil ->
				if String.starts_with? request_path, path do
					conn
				else
					conn |> Phoenix.Controller.redirect(to: redirect) |> halt
				end
			user ->
				assign(conn, :current_user, user)
		end
	end
end