defmodule LiveVueWebsiteWeb.Examples.EncoderLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "EncoderLive page" do
    test "renders the encoder example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/encoder")

      assert html =~ "Custom Encoder"
      assert html =~ "LiveVue.Encoder"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/encoder")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='encoder-preview']")
    end

    test "preview tab contains the embedded EncoderPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/encoder?tab=preview")

      assert has_element?(view, "[id='encoder-preview']")
    end
  end

  describe "EncoderPreview component" do
    test "displays user profile with default encoding", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/encoder?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Encoder")

      assert vue.props["profile"]["name"] == "Ada Lovelace"
      assert vue.props["profile"]["avatar_url"] =~ "size=32"
    end

    test "displays profile with original avatar when option passed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/encoder?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Encoder")

      assert vue.props["profile_original"]["avatar_url"] =~ "size=256"
      assert vue.props["profile_original"]["name"] == "Ada Lovelace"
    end

    test "nested business struct is properly encoded", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/encoder?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Encoder")

      # Check nested business struct
      assert vue.props["profile"]["business"]["name"] == "Analytical Engine Co."
      assert vue.props["profile"]["business"]["industry"] == "Computing"
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/encoder?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/Encoder")
      assert vue.component == "examples/Encoder"
    end
  end
end
