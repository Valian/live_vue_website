defmodule LiveVueWebsiteWeb.Examples.FileUploadLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "FileUploadLive page" do
    test "renders the file upload example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/file-upload")

      assert html =~ "File Upload"
      assert html =~ "useLiveUpload()"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/file-upload")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='file-upload-preview']")
    end

    test "preview tab contains the embedded FileUploadPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/file-upload?tab=preview")

      assert has_element?(view, "[id='file-upload-preview']")
    end
  end

  describe "FileUploadPreview component" do
    test "renders upload component initially with no file uploaded", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/file-upload?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/FileUpload")
      assert vue.props["uploadedFile"] == nil
      assert vue.props["upload"]["name"] == "document"
    end

    test "upload config has correct settings", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/file-upload?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/FileUpload")
      upload = vue.props["upload"]

      assert upload["max_entries"] == 1
      assert upload["auto_upload"] == true
    end

    test "reset event clears uploaded file", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/file-upload?tab=preview")

      form_view = find_live_child(view, "file-upload-preview")

      # First manually set an uploaded file state
      send(
        form_view.pid,
        {:assign_uploaded_file, %{name: "test.txt", size: 100, type: "text/plain"}}
      )

      # Then reset
      render_hook(form_view, "reset", %{})

      vue = LiveVue.Test.get_vue(view, name: "examples/FileUpload")
      assert vue.props["uploadedFile"] == nil
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/file-upload?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/FileUpload")
      assert vue.component == "examples/FileUpload"
    end
  end
end
