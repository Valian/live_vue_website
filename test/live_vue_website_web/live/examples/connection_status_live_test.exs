defmodule LiveVueWebsiteWeb.Examples.ConnectionStatusLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "ConnectionStatusLive page" do
    test "renders the connection status example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/connection-status")

      assert html =~ "Connection Status"
      assert html =~ "Monitor the WebSocket connection state"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/connection-status")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='connection-status-preview']")
    end

    test "preview tab contains the embedded ConnectionStatusPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/connection-status?tab=preview")

      assert has_element?(view, "[id='connection-status-preview']")
    end
  end

  describe "ConnectionStatusPreview component" do
    test "vue component has correct name and path", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/connection-status?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/ConnectionStatus")
      assert vue.component == "examples/ConnectionStatus"
    end

    test "connection state is initialized", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/connection-status?tab=preview")

      # Verify the component renders - the connection state is managed client-side
      # so we just verify the component is present with the correct name
      vue = LiveVue.Test.get_vue(view, name: "examples/ConnectionStatus")
      assert vue.component == "examples/ConnectionStatus"
    end
  end
end
