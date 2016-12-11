defmodule Unlocked.LayoutView do
  use Unlocked.Web, :view

  def current_user(conn) do
    conn.assigns.current_user
  end

end
