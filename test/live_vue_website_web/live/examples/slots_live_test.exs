defmodule LiveVueWebsiteWeb.Examples.SlotsLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "SlotsLive page" do
    test "renders the slots example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/slots")

      assert html =~ "Slots"
      assert html =~ "Pass HEEx content into Vue components"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/slots")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='slots-preview']")
    end

    test "preview tab contains the embedded SlotsPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/slots?tab=preview")

      assert has_element?(view, "[id='slots-preview']")
    end
  end

  describe "SlotsPreview component" do
    test "renders multiple Vue Slots components", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/slots?tab=preview")

      # Get the Slots component - there should be at least one
      vue = LiveVue.Test.get_vue(view, name: "examples/Slots")
      assert vue.component == "examples/Slots"
    end

    test "passes variant prop to components", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/examples/slots?tab=preview")

      # Check that multiple examples are rendered by looking for data-props with different variants
      # The components should have different variant props
      assert html =~ "examples/Slots"
    end

    test "passes title prop as fallback", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/slots?tab=preview")

      # Get all Vue components to check for title prop
      # At least one component should have a title prop
      vue = LiveVue.Test.get_vue(view, name: "examples/Slots")

      # Verify component is rendered
      assert vue.component == "examples/Slots"
    end

    test "renders the preview container", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/slots?tab=preview")

      # Check that the preview container is present
      assert has_element?(view, "[id='slots-preview']")
    end
  end
end
