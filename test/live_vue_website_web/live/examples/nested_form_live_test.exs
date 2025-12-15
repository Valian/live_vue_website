defmodule LiveVueWebsiteWeb.Examples.NestedFormLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "NestedFormLive page" do
    test "renders the nested form example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/nested-form")

      assert html =~ "Nested Objects"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='nested-form-preview']")
    end

    test "preview tab contains the embedded NestedFormPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      assert has_element?(view, "[id='nested-form-preview']")
    end
  end

  describe "NestedFormPreview component" do
    test "renders empty form initially", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")
      assert vue.props["form"]["name"] == "profile"
      assert vue.props["form"]["values"]["name"] == nil
      assert vue.props["form"]["values"]["email"] == nil
    end

    test "validate event updates form with errors for empty fields", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      form_view = find_live_child(view, "nested-form-preview")

      render_hook(form_view, "validate", %{
        "profile" => %{
          "name" => "",
          "email" => "",
          "address" => %{"street" => "", "city" => "", "zip" => ""}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")

      # Should have validation errors
      assert vue.props["form"]["errors"]["name"] != nil
      assert vue.props["form"]["errors"]["email"] != nil

      # Address errors are nested under the "address" key
      address_errors = vue.props["form"]["errors"]["address"]
      assert address_errors["street"] != nil
      assert address_errors["city"] != nil
      assert address_errors["zip"] != nil
    end

    test "validate event shows no errors for valid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      form_view = find_live_child(view, "nested-form-preview")

      render_hook(form_view, "validate", %{
        "profile" => %{
          "name" => "John Doe",
          "email" => "john@example.com",
          "address" => %{
            "street" => "123 Main Street",
            "city" => "San Francisco",
            "zip" => "94102"
          }
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")

      # Should have no errors
      assert vue.props["form"]["errors"]["name"] == nil ||
               vue.props["form"]["errors"]["name"] == []

      assert vue.props["form"]["errors"]["email"] == nil ||
               vue.props["form"]["errors"]["email"] == []

      # Address should have no errors (nil or empty map)
      address_errors = vue.props["form"]["errors"]["address"]
      assert address_errors == nil || address_errors == %{}
    end

    test "validate event shows error for invalid zip code", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      form_view = find_live_child(view, "nested-form-preview")

      render_hook(form_view, "validate", %{
        "profile" => %{
          "name" => "John Doe",
          "email" => "john@example.com",
          "address" => %{
            "street" => "123 Main Street",
            "city" => "San Francisco",
            "zip" => "invalid"
          }
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")

      # ZIP should have format error
      address_errors = vue.props["form"]["errors"]["address"]
      assert address_errors["zip"] != nil && address_errors["zip"] != []
    end

    test "validate event shows error for short street", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      form_view = find_live_child(view, "nested-form-preview")

      render_hook(form_view, "validate", %{
        "profile" => %{
          "name" => "John Doe",
          "email" => "john@example.com",
          "address" => %{
            "street" => "Hi",
            "city" => "San Francisco",
            "zip" => "94102"
          }
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")

      # Street should have length error
      address_errors = vue.props["form"]["errors"]["address"]
      assert address_errors["street"] != nil && address_errors["street"] != []
    end

    test "submit event with valid data resets the form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      form_view = find_live_child(view, "nested-form-preview")

      render_hook(form_view, "submit", %{
        "profile" => %{
          "name" => "John Doe",
          "email" => "john@example.com",
          "address" => %{
            "street" => "123 Main Street",
            "city" => "San Francisco",
            "zip" => "94102"
          }
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")

      # Form should be reset
      assert vue.props["form"]["values"]["name"] == nil
      assert vue.props["form"]["values"]["email"] == nil
    end

    test "submit event with invalid data keeps form with errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      form_view = find_live_child(view, "nested-form-preview")

      render_hook(form_view, "submit", %{
        "profile" => %{
          "name" => "",
          "email" => "",
          "address" => %{"street" => "", "city" => "", "zip" => ""}
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")

      # Should have validation errors
      assert vue.props["form"]["errors"]["name"] != nil
      assert vue.props["form"]["errors"]["email"] != nil
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/nested-form?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/NestedForm")
      assert vue.component == "examples/NestedForm"
    end
  end
end
