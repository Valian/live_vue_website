defmodule LiveVueWebsiteWeb.Examples.EventsLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "EventsLive page" do
    test "renders the events example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/events")

      assert html =~ "Event Handling"
      assert html =~ "Two ways to send events from Vue to LiveView"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='events-preview']")
    end

    test "preview tab contains the embedded EventsPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      assert has_element?(view, "[id='events-preview']")
    end
  end

  describe "EventsPreview component" do
    test "displays empty message list initially", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")
      assert vue.props["messages"] == []
    end

    test "add_message event adds message from pushEvent", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      events_view = find_live_child(view, "events-preview")

      render_hook(events_view, "add_message", %{"text" => "Hello from pushEvent"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")

      assert length(vue.props["messages"]) == 1
      [message] = vue.props["messages"]
      assert message["text"] == "Hello from pushEvent"
      assert message["from"] == "pushEvent"
      assert is_integer(message["id"])
    end

    test "phx_click_message event adds message from phx-click", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      events_view = find_live_child(view, "events-preview")

      render_hook(events_view, "phx_click_message", %{"text" => "Hello from click"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")

      assert length(vue.props["messages"]) == 1
      [message] = vue.props["messages"]
      assert message["text"] == "Hello from click"
      assert message["from"] == "phx-click"
      assert is_integer(message["id"])
    end

    test "clear event empties the message list", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      events_view = find_live_child(view, "events-preview")

      # Add some messages first
      render_hook(events_view, "add_message", %{"text" => "Message 1"})
      render_hook(events_view, "phx_click_message", %{"text" => "Message 2"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")
      assert length(vue.props["messages"]) == 2

      # Clear all messages
      render_hook(events_view, "clear", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")
      assert vue.props["messages"] == []
    end

    test "messages are prepended (newest first)", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      events_view = find_live_child(view, "events-preview")

      render_hook(events_view, "add_message", %{"text" => "First"})
      render_hook(events_view, "add_message", %{"text" => "Second"})
      render_hook(events_view, "add_message", %{"text" => "Third"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")

      messages = vue.props["messages"]
      assert length(messages) == 3

      # Newest should be first
      assert Enum.at(messages, 0)["text"] == "Third"
      assert Enum.at(messages, 1)["text"] == "Second"
      assert Enum.at(messages, 2)["text"] == "First"
    end

    test "messages from different sources are correctly tagged", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      events_view = find_live_child(view, "events-preview")

      render_hook(events_view, "add_message", %{"text" => "From pushEvent"})
      render_hook(events_view, "phx_click_message", %{"text" => "From phx-click"})
      render_hook(events_view, "add_message", %{"text" => "Another pushEvent"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")

      messages = vue.props["messages"]
      assert length(messages) == 3

      # Check the from tags (newest first)
      assert Enum.at(messages, 0)["from"] == "pushEvent"
      assert Enum.at(messages, 1)["from"] == "phx-click"
      assert Enum.at(messages, 2)["from"] == "pushEvent"
    end

    test "each message has a unique id", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      events_view = find_live_child(view, "events-preview")

      render_hook(events_view, "add_message", %{"text" => "One"})
      render_hook(events_view, "add_message", %{"text" => "Two"})
      render_hook(events_view, "add_message", %{"text" => "Three"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")

      ids = Enum.map(vue.props["messages"], & &1["id"])
      assert length(Enum.uniq(ids)) == 3
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/events?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Events")
      assert vue.component == "examples/Events"
    end
  end
end
