# PokeViewer

An iOS application which acts like a Pokedex where you can view Pokemon sprites, abilities and stats.

Support for all iOS devices (13.0+) using AutoLayout (includes UI changes based on iOS device size classes) and macOS (10.15+) using Mac Catalyst.

# Technologies and Frameworks Used

- **URLSession** to retrieve data from **PokeAPI** in the form of **JSON** and **Image Data**.
- **Codable** to decode **JSON** data.
- On-disk caching with **URLCache** to cache **URLRequests** made by the application.
- **UITableView** to display the Pokemon data.
- **UINib** to specify custom design files for **UITableViewCell**.
- **UISearchBar** to filter using Pokemon names.
- **Grand Central Dispatch** to enhance user experience by scheduling download tasks on **Background Queue**.

# Screenshots

# Architecture

![Architecture](https://github.com/rohit-lunavara/PokeViewer/blob/master/PokeViewer-Class-Diagram.svg?raw=true)

- Extensive use of delegation ensures separation of concerns.
- Custom **RequestManager** class handles **URLRequests**, **URLCache** and provides callbacks for success and failure to classes implementing the **RequestManagerDelegate** protocol.
- Optimizing performance by reducing the number of **URLRequests** via **Lazy Loading** the Pokemon list (loading only 100 Pokemon at a time) and **Caching** as mentioned above.

# Miscellaneous

- All **Constants** such as **UIColors**, **ReuseIdentifiers**, **Static URLs**, etc are stored in the **Constants** file.
- Extension for **UIColor** to accept hex codes and blend two different **UIColors**.

# Future Scope

- Filter using 
- Show additional information for Abilities, Stats, etc in a **WKWebView**.
- Share Pokemon information using **UIActivityViewController**.
- Customize **UITableView** and **UITableViewCell** design to make it look like a Pokedex.

# Bugfixes

- Reload **UITableView** section containing **LoadingCell** when Pokemon list is being updated.

# Credits

- [**PokeAPI**](https://pokeapi.co/) for providing a free API for Pokemon data.
