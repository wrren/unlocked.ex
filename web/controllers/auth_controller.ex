defmodule Unlocked.AuthController do
	use Unlocked.Web, :controller
	plug Ueberauth
	alias Ueberauth.Strategy.Helpers
	
	def index(conn, _params) do

	end

	def request(conn, _params) do
		render(conn, "request.html", callback_url: Helpers.callback_url(conn))
	end

	def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Unlocked.User.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end