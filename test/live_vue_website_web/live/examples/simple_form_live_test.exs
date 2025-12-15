defmodule LiveVueWebsiteWeb.Examples.SimpleFormLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "SimpleFormLive page" do
    test "renders the simple form example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/simple-form")

      assert html =~ "Simple Form"
      assert html =~ "useLiveForm()"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form")

      # Switch to liveview tab
      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      # Switch to vue tab
      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      # Switch back to preview
      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='simple-form-preview']")
    end

    test "preview tab contains the embedded SimpleFormPreview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      assert has_element?(view, "[id='simple-form-preview']")
    end
  end

  describe "SimpleFormPreview component" do
    test "renders empty form initially", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")
      assert vue.props["form"]["name"] == "contact"
      assert vue.props["form"]["values"]["name"] == nil
      assert vue.props["form"]["values"]["email"] == nil
      assert vue.props["form"]["values"]["consent"] == nil
    end

    test "validate event updates form with errors for empty fields", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "validate", %{
        "contact" => %{"name" => "", "email" => ""}
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Should have validation errors
      assert vue.props["form"]["errors"]["name"] != nil
      assert vue.props["form"]["errors"]["email"] != nil
    end

    test "validate event shows no errors for valid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "validate", %{
        "contact" => %{
          "name" => "John Doe",
          "email" => "john@example.com",
          "consent" => "true"
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Should have no errors
      assert vue.props["form"]["errors"]["name"] == nil ||
               vue.props["form"]["errors"]["name"] == []

      assert vue.props["form"]["errors"]["email"] == nil ||
               vue.props["form"]["errors"]["email"] == []
    end

    test "validate event shows error for short name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "validate", %{
        "contact" => %{
          "name" => "A",
          "email" => "test@test.com",
          "consent" => "true"
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Name should have length error
      errors = vue.props["form"]["errors"]["name"]
      assert errors != nil && errors != []
    end

    test "validate event shows error for invalid email", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "validate", %{
        "contact" => %{
          "name" => "John",
          "email" => "not-an-email",
          "consent" => "true"
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Email should have format error
      errors = vue.props["form"]["errors"]["email"]
      assert errors != nil && errors != []
    end

    test "validate event shows error when consent not accepted", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "validate", %{
        "contact" => %{"name" => "John", "email" => "john@test.com", "consent" => "false"}
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Consent should have acceptance error
      errors = vue.props["form"]["errors"]["consent"]
      assert errors != nil && errors != []
    end

    test "submit event with valid data clears the form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "submit", %{
        "contact" => %{
          "name" => "John Doe",
          "email" => "john@example.com",
          "consent" => "true"
        }
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Form values should be cleared after successful submit
      assert vue.props["form"]["values"]["name"] == nil
      assert vue.props["form"]["values"]["email"] == nil
    end

    test "submit event with invalid data keeps form with errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      form_view = find_live_child(view, "simple-form-preview")

      render_hook(form_view, "submit", %{
        "contact" => %{"name" => "", "email" => ""}
      })

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")

      # Should have validation errors
      assert vue.props["form"]["errors"]["name"] != nil
      assert vue.props["form"]["errors"]["email"] != nil
    end

    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/simple-form?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/SimpleForm")
      assert vue.component == "examples/SimpleForm"
    end
  end
end
