# VSCode Goodies

## snippets.json

To install these custom VS Code snippets, select "Configure User Snippets" under
"Code > Settings" (on Windows, select "User Snippets" under
"File > Preferences"), and then select "elixir.json". Paste the contents of `snippets.json` into that file.

If you already have snippets in that file, you'll need to put all the snippets in one top-level JavaScript object, so remove the outer curly braces in `snippets.json`.

## settings.json

To add these settings, open your user settings in VS Code using the "Preferences: Open Settings (JSON)" command.

All the settings need to be in a top-level JavaScript object, so remove the outer curly braces in `settings.json`.

## Extensions

- [Material Theme](https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme) extension for the color theme

- [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls) extension for Elixir support

- [Phoenix Framework](https://marketplace.visualstudio.com/items?itemName=phoenixframework.phoenix) extension for syntax highlighting of HEEx templates

- [Simple Ruby ERB](https://marketplace.visualstudio.com/items?itemName=vortizhe.simple-ruby-erb) extension for toggling `<%= %>` tags
