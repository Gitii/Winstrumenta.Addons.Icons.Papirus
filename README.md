# Winstrumenta.Addons.Icons.Papirus
`Winstrumenta.Addons.Icons.Papirus` is an optional package (addon) for 
[Winstrumenta](https://github.com/Gitii/Winstrumenta). `Winstrumenta` is a collection of utility programs for `WSL` and `WSA`.
This repository contains the source code for creating and uploading the optional package. When installed, `Package Manager` will display matching icons for the selected packages.

## Icons
The icons are copied from [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) at build time. Papirus is a free and open source SVG icon theme for Linux. 
Papirus icon theme is free and open source project distributed under the terms of the GNU General Public License, version 3.

## How does icon themes work in Winstrumenta?
Icon themes consist of two main files:
* `icons.zip`
 A zip file that contains only vector-images (the icons).
* `mapping.csv`
  A semicolon-separated file with the format `<look up key>;<icon file name>`.
  `Winstrumenta` parses the `mapping.csv` file and uses it to extract the correct file inside `icons.zip`.

Using a mapping file and archive is done to save bandwidth. A lot of keys point to the same file inside the archive. Bundling all icons in a zip limits IO operations.
By dereferencing the mapping (duplicating the icons in order to achive a 1:1 mapping between keys and icons), this could be simplified to a simple `File.OpenRead($"{lookupKey}.svg")`.

Both files are packed in a `msix` package and is installed by the user if desired.
At runtime `Windows` will mount the contents of the package (both files) in the `VFS` of `Winstrumenta`. `Winstrumenta` will then detect the package and read the files using the [`Windows.Storage api`](https://docs.microsoft.com/en-us/uwp/api/windows.storage?view=winrt-22000) of `UWP`.

## License
The content of this repository is free and open-source project distributed under the terms of the GNU General Public License, version 3. See the [`LICENSE`](./LICENSE) file for details. 

`Winstrumenta.Addons.Icons.Papirus` is a plugin and [is considered separate](https://www.gnu.org/licenses/gpl-faq.html#GPLPlugins) from 
`Winstrumenta` (which is distributed under the terms of the MIT License). There is no executable code contained in `Winstrumenta.Addons.Icons.Papirus` and therefore `Winstrumenta` **doesn't** use fork and exec to invoke plug-ins, and it **doesn't** establish intimate communication by sharing *complex* data structures, and it **doesn't** ship *complex* data structures back and forth.

See section `How does icon themes work in Winstrumenta?` for a detailed explanation how plugins are loaded by `Winstrumenta`.
