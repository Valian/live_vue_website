defmodule LiveVueWebsiteWeb.LandingLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @tag :skip
  test "renders the landing page", %{conn: conn} do
    # This test requires vite assets to be built first
    # Run: cd assets && npx vite build
    {:ok, _view, html} = live(conn, ~p"/")
    assert html =~ "Vue"
    assert html =~ "LiveView"
    assert html =~ "End-to-End Reactivity"
  end
end
