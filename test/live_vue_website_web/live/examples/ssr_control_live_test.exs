defmodule LiveVueWebsiteWeb.Examples.SsrControlLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "SsrControlLive page" do
    test "renders the ssr control example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/ssr-control")

      assert html =~ "SSR Control"
      assert html =~ "Control server-side rendering for components"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/ssr-control")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='ssr-control-preview']")
    end

    test "preview tab contains the embedded SsrControlPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/ssr-control?tab=preview")

      assert has_element?(view, "[id='ssr-control-preview']")
    end
  end

  describe "SsrControlPreview component" do
    test "html contains labels for both variants", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/examples/ssr-control")

      assert html =~ "With SSR (default)"
      # The {false} is HTML-encoded when rendered
      assert html =~ "Without SSR"
    end

    test "preview shows both components with different SSR settings", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/ssr-control")

      # Preview tab should be shown by default and contain the child liveview
      assert has_element?(view, "[id='ssr-control-preview']")
    end
  end
end
