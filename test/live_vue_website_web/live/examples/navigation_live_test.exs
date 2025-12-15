defmodule LiveVueWebsiteWeb.Examples.NavigationLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "NavigationLive page" do
    test "renders the navigation example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/navigation")

      assert html =~ "Navigation"
      assert html =~ "LiveView-aware navigation"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='navigation-preview']")
    end

    test "preview tab contains the embedded NavigationPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation?tab=preview")

      assert has_element?(view, "[id='navigation-preview']")
    end
  end

  describe "NavigationPreview component" do
    test "displays initial path and empty query params", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      # Child LiveViews can't use handle_params, so values are from mount
      assert vue.props["current_path"] == "/examples/navigation"
      assert vue.props["query_params"] == %{}
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      assert vue.component == "examples/Navigation"
    end

    test "update_location event updates path and query params", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      navigation_view = find_live_child(view, "navigation-preview")

      render_hook(navigation_view, "update_location", %{
        "path" => "/new/path",
        "query" => %{"foo" => "bar"}
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      assert vue.props["current_path"] == "/new/path"
      assert vue.props["query_params"]["foo"] == "bar"
    end
  end
end
