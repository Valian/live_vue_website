defmodule LiveVueWebsiteWeb.Examples.StreamsLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "StreamsLive page" do
    test "renders the streams example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/streams")

      assert html =~ "Phoenix Streams"
      assert html =~ "stream()"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/streams")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='streams-preview']")
    end

    test "preview tab contains the embedded StreamsPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/streams?tab=preview")

      assert has_element?(view, "[id='streams-preview']")
    end
  end

  describe "StreamsPreview component" do
    test "displays welcome message initially", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/streams?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Streams")

      # Initial render has upsert op with welcome message
      upsert_op = Enum.find(vue.streams_diff, fn [op | _] -> op == "upsert" end)
      assert upsert_op != nil
      ["upsert", _path, welcome] = upsert_op
      assert welcome["role"] == "assistant"
      assert welcome["content"] =~ "demo AI"
      assert vue.props["isThinking"] == false
    end

    test "sends message and receives AI response", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/streams?tab=preview")

      child_view = find_live_child(view, "streams-preview")

      # Send a message
      render_hook(child_view, "send_message", %{"content" => "Hello"})

      # Check user message was added and thinking state is true
      vue = LiveVue.Test.get_vue(view, name: "examples/Streams")

      # streams_diff contains "upsert" operations for stream_insert
      upsert_op = Enum.find(vue.streams_diff, fn [op | _] -> op == "upsert" end)
      assert upsert_op != nil
      ["upsert", _path, item] = upsert_op
      assert item["role"] == "user"
      assert item["content"] == "Hello"
      assert vue.props["isThinking"] == true

      # Wait for async response (max ~1.5s delay + buffer)
      Process.sleep(2000)

      # Re-render to get updated state
      render(view)
      vue = LiveVue.Test.get_vue(view, name: "examples/Streams")

      upsert_op = Enum.find(vue.streams_diff, fn [op | _] -> op == "upsert" end)
      assert upsert_op != nil
      ["upsert", _path, item] = upsert_op
      assert item["role"] == "assistant"
      assert vue.props["isThinking"] == false
    end

    test "ignores empty messages", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/streams?tab=preview")

      child_view = find_live_child(view, "streams-preview")

      # Try to send empty message
      render_hook(child_view, "send_message", %{"content" => "   "})

      vue = LiveVue.Test.get_vue(view, name: "examples/Streams")
      # Only the welcome message upsert should exist (from mount), no user message
      upsert_ops = Enum.filter(vue.streams_diff, fn [op | _] -> op == "upsert" end)
      assert length(upsert_ops) == 1
      [["upsert", _path, msg]] = upsert_ops
      assert msg["role"] == "assistant"
      assert vue.props["isThinking"] == false
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/streams?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Streams")
      assert vue.component == "examples/Streams"
    end
  end
end
