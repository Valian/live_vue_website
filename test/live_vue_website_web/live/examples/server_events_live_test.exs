defmodule LiveVueWebsiteWeb.Examples.ServerEventsLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "ServerEventsLive page" do
    test "renders the server events example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/server-events")

      assert html =~ "Server Events"
      assert html =~ "Server-to-client communication"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='server-events-preview']")
    end

    test "preview tab contains the embedded ServerEventsPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      assert has_element?(view, "[id='server-events-preview']")
    end
  end

  describe "ServerEventsPreview component" do
    test "displays initial notification count of 0", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      assert vue.props["notification_count"] == 0
    end

    test "trigger_notification event increments notification count", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      server_events_view = find_live_child(view, "server-events-preview")

      render_hook(server_events_view, "trigger_notification", %{"type" => "info"})

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      assert vue.props["notification_count"] == 1

      render_hook(server_events_view, "trigger_notification", %{"type" => "success"})

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      assert vue.props["notification_count"] == 2
    end

    test "trigger_notification event with different types", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      server_events_view = find_live_child(view, "server-events-preview")

      for type <- ["info", "success", "warning", "error"] do
        render_hook(server_events_view, "trigger_notification", %{"type" => type})
      end

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      assert vue.props["notification_count"] == 4
    end

    test "trigger_alert event does not increment notification count", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      server_events_view = find_live_child(view, "server-events-preview")

      render_hook(server_events_view, "trigger_alert", %{
        "message" => "Test alert message"
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      # Alert events don't increment notification count
      assert vue.props["notification_count"] == 0
    end

    test "multiple trigger_notification calls increment count correctly", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      server_events_view = find_live_child(view, "server-events-preview")

      # Trigger 5 notifications
      for i <- 1..5 do
        render_hook(server_events_view, "trigger_notification", %{
          "type" => if(rem(i, 2) == 0, do: "info", else: "success")
        })
      end

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      assert vue.props["notification_count"] == 5
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      assert vue.component == "examples/ServerEvents"
    end

    test "notification count persists across different event types", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/server-events?tab=preview")

      server_events_view = find_live_child(view, "server-events-preview")

      # Mix of notifications and alerts
      render_hook(server_events_view, "trigger_notification", %{"type" => "info"})
      render_hook(server_events_view, "trigger_alert", %{"message" => "Alert 1"})
      render_hook(server_events_view, "trigger_notification", %{"type" => "warning"})
      render_hook(server_events_view, "trigger_alert", %{"message" => "Alert 2"})
      render_hook(server_events_view, "trigger_notification", %{"type" => "error"})

      vue = LiveVue.Test.get_vue(view, name: "examples/ServerEvents")
      # Only notifications increment the count
      assert vue.props["notification_count"] == 3
    end
  end
end
