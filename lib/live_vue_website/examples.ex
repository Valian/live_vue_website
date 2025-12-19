defmodule LiveVueWebsite.Examples do
  @moduledoc """
  Catalog of LiveVue examples with metadata.
  """

  @examples [
    %{
      category: "Getting Started",
      items: [
        %{
          id: "counter",
          title: "Counter",
          description: "Pass assigns as props to Vue, handle clicks in LiveView",
          icon: "hero-plus-circle",
          status: :ready
        },
        %{
          id: "encoder",
          title: "Custom Encoder",
          description: "Send Ecto schemas and custom structs as props",
          icon: "hero-code-bracket",
          status: :ready
        }
      ]
    },
    %{
      category: "Events",
      items: [
        %{
          id: "events",
          title: "Event Handling",
          description: "Send events from Vue to your handle_event callbacks",
          icon: "hero-cursor-arrow-rays",
          status: :ready
        },
        %{
          id: "server-events",
          title: "Server Events",
          description: "Push events from LiveView to Vue (like push_event)",
          icon: "hero-bell-alert",
          status: :ready
        }
      ]
    },
    %{
      category: "Navigation",
      items: [
        %{
          id: "navigation",
          title: "Navigation",
          description: "Use push_patch and push_navigate from Vue components",
          icon: "hero-arrow-path",
          status: :ready
        }
      ]
    },
    %{
      category: "Forms",
      items: [
        %{
          id: "simple-form",
          title: "Simple Form",
          description: "Use Ecto changesets for validation in Vue forms",
          icon: "hero-document-text",
          status: :ready
        },
        %{
          id: "nested-form",
          title: "Nested Objects",
          description: "Handle embedded schemas and nested changesets",
          icon: "hero-square-3-stack-3d",
          status: :ready
        },
        %{
          id: "array-form",
          title: "Dynamic Arrays",
          description: "Add, remove, reorder items in has_many associations",
          icon: "hero-queue-list",
          status: :ready
        }
      ]
    },
    %{
      category: "Uploads",
      items: [
        %{
          id: "file-upload",
          title: "File Upload",
          description: "Use allow_upload with Vue drag-and-drop UI",
          icon: "hero-cloud-arrow-up",
          status: :ready
        }
      ]
    },
    %{
      category: "Real-time",
      items: [
        %{
          id: "streams",
          title: "Phoenix Streams",
          description: "Render LiveView streams in Vue components",
          icon: "hero-signal",
          status: :ready
        },
        %{
          id: "connection-status",
          title: "Connection Status",
          description: "React to socket disconnects and reconnects",
          icon: "hero-wifi",
          status: :ready
        }
      ]
    },
    %{
      category: "Advanced",
      items: [
        %{
          id: "slots",
          title: "Slots",
          description: "Pass HEEx markup into Vue component slots",
          icon: "hero-puzzle-piece",
          status: :ready
        },
        %{
          id: "ssr-control",
          title: "SSR Control",
          description: "Skip server rendering for browser-only libraries",
          icon: "hero-server",
          status: :ready
        },
        %{
          id: "vue-sigil",
          title: "Vue Sigil",
          description: "Write Vue components inline in your LiveView",
          icon: "hero-sparkles",
          status: :ready
        }
      ]
    }
  ]

  @doc """
  Returns the full examples catalog with categories, descriptions, and status.
  """
  def catalog, do: @examples

  @doc """
  Returns navigation-friendly data (id, title, icon per item).
  """
  def nav do
    Enum.map(@examples, fn category ->
      %{
        category: category.category,
        items:
          Enum.map(category.items, fn item ->
            Map.take(item, [:id, :title, :icon])
          end)
      }
    end)
  end

  @doc """
  Returns list of example IDs that are ready (not coming soon).
  """
  def active_ids do
    @examples
    |> Enum.flat_map(& &1.items)
    |> Enum.filter(&(&1.status == :ready))
    |> Enum.map(& &1.id)
  end
end
