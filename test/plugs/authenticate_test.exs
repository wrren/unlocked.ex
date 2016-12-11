defmodule Unlocked.Plug.AuthenticateTest do
	use ExUnit.Case, async: true
	use Plug.Test

	@opts Unlocked.Router.init([])
	
	test "Redirects if there's no current user" do
		conn = conn(:get, "/")

		conn = Unlocked.Router.call(conn, @opts)

		assert conn.status == 301
	end
	
end