defmodule Unlocked.PageController do
  use Unlocked.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
