defmodule LiveVueWebsiteWeb.LandingLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @tag :skip
  test "renders the landing page", %{conn: conn} do
    # This test requires vite assets to be built first
    # Run: cd assets && npx vite build
    {:ok, _view, html} = live(conn, ~p"/")
    assert html =~ "Vue"
    assert html =~ "Phoenix LiveView"
    assert html =~ "seamless end-to-end reactivity"
  end
end
