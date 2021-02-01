# Pokedemo

An iOS application that retrieves and shows Pokémon information from an external API.

## Desenvolvimento

1. Application developed using Swift
2. MVVM architecture
3. API used: PokeAPI (https://pokeapi.co/).

#### WebServives

- ServiceAPI: Responsable for the communication between the application and the API.

#### Classes

- PokemonListViewController: First screen. Shows all fetched pokemons in a UICollectionView. Has a search bar that allows the user to search for a specific Pokemon by ID or by Name. When the user selected one cell, the PokemonDetailViewController is presented.
- PokemonDetailViewController: Shows Pokemon Information. Namely, name, id, height, weight and type(s). In addition it also shows a front and a back image of the Pokémon.

#### ViewModels

- PokemonListViewModel
- PokemonDetailViewModel
- PokemonCellViewModel

#### Model

- Pokemon

#### Custom UI

- PokemonCollectionViewCell: Used in the PokemonListViewController UICollectionView

#### Extensions

1. UIFont
2. UIColor

### Pokemon Data Retrieved

- Id 
- Name
- Front Default Picture
- Back Default Picture
- Height
- Weight
- Type(s)

## TODO List

- [x] Fetch Pokemons from API
- [x] Pagination
- [x] Support multiple device orientation
- [x] iPad full support
- [x] Search Pokemon by ID
- [x] Search Pokemon by Name
- [x] Add app icon
- [x] Set app launch screen
- [x] Show Pokémon Height information
- [x] Show Pokémon Weight information
- [x] Show Pokémon Type(s) information
- [x] Add UITesting
- [x] Add UnitTesting
- [x] Allow dependency injection
- [ ] Swipe between Pokémon details (previous and next)
- [ ] Save favorite Pokémons
- [ ] Add Pokémon moves information
- [ ] Add Pokémon ability information
- [ ] Add Pokémon basic stat information
- [ ] Add custom loading animation
- [ ] Improve readme.md with app architecture
