defmodule LiveVueWebsiteWeb.Examples.ExampleSource do
  @moduledoc """
  Utilities for reading and transforming example source code for display.

  This module provides compile-time functions to read source files and transform
  them to look like generic "MyAppWeb" examples rather than site-specific code.
  """

  @doc """
  Returns the Elixir source code for a preview module, transformed for display.

  Takes a name like "Counter" and reads the corresponding `counter_preview.ex` file,
  then applies transformations to make it look like a generic example:
  - Renames module from `LiveVueWebsiteWeb.Examples.NamePreview` to `MyAppWeb.NameLive`
  - Replaces `LiveVueWebsiteWeb` with `MyAppWeb`
  - Replaces `examples/Name` with `Name` in component paths
  - Removes @moduledoc
  - Removes `layout: false`

  ## Examples

      # In module attributes (compile-time):
      @elixir_source ExampleSource.elixir_source("Counter")

  """
  defmacro elixir_source(name) do
    quote bind_quoted: [name: name] do
      snake_name = Macro.underscore(name)

      path =
        Path.join(File.cwd!(), "lib/live_vue_website_web/live/examples/#{snake_name}_preview.ex")

      # Register external resource for recompilation
      @external_resource path

      File.read!(path)
      |> String.replace(
        "LiveVueWebsiteWeb.Examples.#{name}Preview",
        "MyAppWeb.#{name}Live"
      )
      |> String.replace("LiveVueWebsiteWeb", "MyAppWeb")
      |> String.replace("examples/#{name}", name)
      |> String.replace(~r/\s*@moduledoc.*?\"\"\".*?\"\"\"[\r\n]*/s, "\n")
      |> String.replace(", layout: false", "")
      |> String.trim()
    end
  end

  @doc """
  Returns the Vue source code for a component.

  Takes a name like "Counter" and reads the corresponding `Counter.vue` file
  from `assets/vue/examples/`.

  ## Examples

      # In module attributes (compile-time):
      @vue_source ExampleSource.vue_source("Counter")

  """
  defmacro vue_source(name) do
    quote bind_quoted: [name: name] do
      path = Path.join(File.cwd!(), "assets/vue/examples/#{name}.vue")

      # Register external resource for recompilation
      @external_resource path

      File.read!(path)
    end
  end
end
