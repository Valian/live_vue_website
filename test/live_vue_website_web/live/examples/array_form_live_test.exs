defmodule LiveVueWebsiteWeb.Examples.ArrayFormLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "ArrayFormLive page" do
    test "renders the array form example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/array-form")

      assert html =~ "Dynamic Arrays"
      assert html =~ "fieldArray()"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='array-form-preview']")
    end

    test "preview tab contains the embedded ArrayFormPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      assert has_element?(view, "[id='array-form-preview']")
    end
  end

  describe "ArrayFormPreview component" do
    test "renders empty form with no tags initially", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")
      assert vue.props["form"]["name"] == "post"
      assert vue.props["form"]["values"]["title"] == nil

      assert vue.props["form"]["values"]["tags"] == nil ||
               vue.props["form"]["values"]["tags"] == []
    end

    test "validate event updates form with errors for empty title", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "validate", %{
        "post" => %{
          "title" => "",
          "tags" => %{}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Should have validation error for title
      assert vue.props["form"]["errors"]["title"] != nil
    end

    test "validate event shows no errors for valid title with no tags", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "validate", %{
        "post" => %{
          "title" => "My Post Title",
          "tags" => %{}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Should have no errors
      assert vue.props["form"]["errors"]["title"] == nil ||
               vue.props["form"]["errors"]["title"] == []
    end

    test "validate event shows errors for empty tag name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "validate", %{
        "post" => %{
          "title" => "My Post Title",
          "tags" => %{"0" => %{"name" => ""}, "1" => %{"name" => ""}}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Each empty tag should have an error in the nested structure
      tag_errors = vue.props["form"]["errors"]["tags"]
      assert is_list(tag_errors)
      assert length(tag_errors) == 2
      assert Enum.at(tag_errors, 0)["name"] != nil
      assert Enum.at(tag_errors, 1)["name"] != nil
    end

    test "validate event shows no errors for valid tags", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "validate", %{
        "post" => %{
          "title" => "My Post Title",
          "tags" => %{"0" => %{"name" => "elixir"}, "1" => %{"name" => "phoenix"}}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Should have no tag errors (nil or empty list or all nil entries)
      tag_errors = vue.props["form"]["errors"]["tags"]
      assert tag_errors == nil || tag_errors == [] || Enum.all?(tag_errors, &is_nil/1)
    end

    test "validate event shows error for short tag name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "validate", %{
        "post" => %{
          "title" => "My Post Title",
          "tags" => %{"0" => %{"name" => "a"}}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Short tag should have an error
      tag_errors = vue.props["form"]["errors"]["tags"]
      assert is_list(tag_errors)
      assert length(tag_errors) == 1
      assert Enum.at(tag_errors, 0)["name"] != nil
    end

    test "submit event with valid data resets the form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "submit", %{
        "post" => %{
          "title" => "My Post Title",
          "tags" => %{"0" => %{"name" => "elixir"}, "1" => %{"name" => "phoenix"}}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Form should be reset
      assert vue.props["form"]["values"]["title"] == nil
    end

    test "submit event with invalid data keeps form with errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      form_view = find_live_child(view, "array-form-preview")

      render_hook(form_view, "submit", %{
        "post" => %{
          "title" => "",
          "tags" => %{"0" => %{"name" => ""}}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")

      # Should have validation errors
      assert vue.props["form"]["errors"]["title"] != nil

      tag_errors = vue.props["form"]["errors"]["tags"]
      assert is_list(tag_errors)
      assert length(tag_errors) == 1
      assert Enum.at(tag_errors, 0)["name"] != nil
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/array-form?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/ArrayForm")
      assert vue.component == "examples/ArrayForm"
    end
  end
end
