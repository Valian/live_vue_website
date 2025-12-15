defmodule LiveVueWebsiteWeb.Examples.AnimatedCounterLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "AnimatedCounterLive page" do
    test "renders the animated counter example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/animated-counter")

      assert html =~ "Animated Counter"
      assert html =~ "Combine server state updates with smooth Vue transitions"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='animated-counter-preview']")
    end

    test "preview tab contains the embedded AnimatedCounterPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      assert has_element?(view, "[id='animated-counter-preview']")
    end
  end

  describe "AnimatedCounterPreview component" do
    test "displays initial count of 0", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 0
    end

    test "inc event with diff parameter increments count by diff value", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      counter_view = find_live_child(view, "animated-counter-preview")

      # Increment by 5
      render_hook(counter_view, "inc", %{"diff" => "5"})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 5

      # Increment by 5 more
      render_hook(counter_view, "inc", %{"diff" => "5"})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 10
    end

    test "inc event without diff parameter decrements count by 1", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      counter_view = find_live_child(view, "animated-counter-preview")

      # Start with some increments
      render_hook(counter_view, "inc", %{"diff" => "5"})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 5

      # Decrement by 1
      render_hook(counter_view, "inc", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 4
    end

    test "reset event sets count back to 0", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      counter_view = find_live_child(view, "animated-counter-preview")

      # Increment first
      render_hook(counter_view, "inc", %{"diff" => "15"})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 15

      # Reset
      render_hook(counter_view, "reset", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 0
    end

    test "multiple operations work correctly in sequence", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      counter_view = find_live_child(view, "animated-counter-preview")

      # Series of operations
      render_hook(counter_view, "inc", %{"diff" => "5"})
      render_hook(counter_view, "inc", %{"diff" => "5"})
      render_hook(counter_view, "inc", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 9

      render_hook(counter_view, "reset", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 0

      render_hook(counter_view, "inc", %{"diff" => "5"})

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.props["count"] == 5
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/animated-counter?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/AnimatedCounter")
      assert vue.component == "examples/AnimatedCounter"
    end
  end
end
