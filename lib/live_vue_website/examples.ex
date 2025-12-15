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
          description: "Server state, local Vue state, phx-click, transitions",
          icon: "hero-plus-circle",
          status: :ready
        },
        %{
          id: "encoder",
          title: "Custom Encoder",
          description: "Pass custom structs with @derive and defimpl",
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
          description: "pushEvent, phx-click, and useLiveVue()",
          icon: "hero-cursor-arrow-rays",
          status: :ready
        },
        %{
          id: "server-events",
          title: "Server Events",
          description: "useLiveEvent() for server-pushed notifications",
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
          description: "Link component with patch, navigate, href",
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
          description: "useLiveForm() with Ecto validation",
          icon: "hero-document-text",
          status: :ready
        },
        %{
          id: "nested-form",
          title: "Nested Objects",
          description: "Nested fields with dot notation paths",
          icon: "hero-square-3-stack-3d",
          status: :ready
        },
        %{
          id: "array-form",
          title: "Dynamic Arrays",
          description: "fieldArray() with add, remove, move",
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
          description: "useLiveUpload() with progress tracking",
          icon: "hero-cloud-arrow-up",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Real-time",
      items: [
        %{
          id: "streams",
          title: "Phoenix Streams",
          description: "Efficient list updates with stream()",
          icon: "hero-signal",
          status: :ready
        },
        %{
          id: "connection-status",
          title: "Connection Status",
          description: "useLiveConnection() for offline handling",
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
          description: "Default and named slots with HEEX content",
          icon: "hero-puzzle-piece",
          status: :ready
        },
        %{
          id: "ssr-control",
          title: "SSR Control",
          description: "Disable SSR for client-only components",
          icon: "hero-server",
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
