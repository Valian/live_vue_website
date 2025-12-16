defmodule LiveVueWebsiteWeb.Examples.CounterLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "CounterLive page" do
    test "renders the counter example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/counter")

      assert html =~ "Counter"
      assert html =~ "The classic counter example"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='counter-preview']")
    end

    test "preview tab contains the embedded CounterPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      assert has_element?(view, "[id='counter-preview']")
    end
  end

  describe "CounterPreview component" do
    test "displays initial count of 0", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 0
    end

    test "inc event increments count by diff value", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      # Get the nested live view for the counter preview
      counter_view = find_live_child(view, "counter-preview")

      # Increment by 5
      render_hook(counter_view, "inc", %{"diff" => "5"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 5

      # Increment by 3 more
      render_hook(counter_view, "inc", %{"diff" => "3"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 8
    end

    test "inc event with negative diff decrements count", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      counter_view = find_live_child(view, "counter-preview")

      # Start with some increments
      render_hook(counter_view, "inc", %{"diff" => "10"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 10

      # Decrement by 4
      render_hook(counter_view, "inc", %{"diff" => "-4"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 6
    end

    test "reset event sets count back to 0", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      counter_view = find_live_child(view, "counter-preview")

      # Increment first
      render_hook(counter_view, "inc", %{"diff" => "15"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 15

      # Reset
      render_hook(counter_view, "reset", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 0
    end

    test "multiple operations work correctly in sequence", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      counter_view = find_live_child(view, "counter-preview")

      # Series of operations
      render_hook(counter_view, "inc", %{"diff" => "5"})
      render_hook(counter_view, "inc", %{"diff" => "3"})
      render_hook(counter_view, "inc", %{"diff" => "-2"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 6

      render_hook(counter_view, "reset", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 0

      render_hook(counter_view, "inc", %{"diff" => "1"})

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.props["count"] == 1
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/counter?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
      assert vue.component == "examples/Counter"
    end
  end
end
