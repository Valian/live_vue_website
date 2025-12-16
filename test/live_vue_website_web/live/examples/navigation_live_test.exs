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

      # Switch back to preview - vue component should be rendered
      view |> element("a[href='?tab=preview']") |> render_click()
      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      assert vue.component == "examples/Navigation"
    end
  end

  describe "Navigation component" do
    test "displays path and query params from handle_params", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      assert vue.props["currentPath"] == "/examples/navigation"
      assert vue.props["queryParams"] == %{}
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      assert vue.component == "examples/Navigation"
    end

    test "query params are updated via handle_params on patch", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation")

      # Patch with a query param (excluding tab which is used by the page)
      view |> element("a[href='?tab=preview']") |> render_click()

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      # The tab param is filtered out, so queryParams should be empty
      assert vue.props["queryParams"] == %{}
      assert vue.props["currentPath"] == "/examples/navigation"
    end

    test "query params with demo param are passed to vue component", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/navigation?demo=true")

      vue = LiveVue.Test.get_vue(view, name: "examples/Navigation")
      assert vue.props["queryParams"]["demo"] == "true"
    end
  end
end
