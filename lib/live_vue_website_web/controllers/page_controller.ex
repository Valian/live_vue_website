defmodule LiveVueWebsiteWeb.PageController do
  use LiveVueWebsiteWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
