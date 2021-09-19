# CoinTracker

This is an app to track Bitcoin price in the last fortnight.
It has two screens:
	- **List screen**: Shows the Bitcoin price in Euros for each of the last 14 days and today in the rows.
	- **Detail screen**: On tap of any row on List screen, the price details for that day are displayed on the detail screen. Here, the price is shown in Euros, US Dollar and GB Pound on that day based on the forex rates on that day.

## Installation
1. Clone or download the project and open `CoinTracker.xcodeproj` file using Xcode 12. Preferably Xcode 12.5
2. Ensure the target scheme is set to `CoinTracker`. 
3. Build and Run the project.

## Architecture
The ideal architecture for this app should solve for:
- Having separate targets for each feature and their tests
- Segregating different parts of the app based on Single Responsibility Principle.
- Being not overly complex to understand

The app is built using VIPER Architecture. It consists of two main feature frameworks `CoinHistory` and `PriceDetailModule` for both screens of the app. These feature frameworks also have respective test frameworks which cover unit tests. It also has a kit framework known as `Utilities` for common extensions and network requests.

**Structure**:
- CoinTracker
	- CoinHistory
	- CoinHistoryTests
	- PriceDetailModule
	- PriceDetailModuleTests
	- Utilities

**Motivation for using VIPER:** 
MVVM does not separate the navigation and network interaction to different layers. It will also not elegantly handle dependencies between different frameworks. 

In order to achieve a layered architecture where Single Responsibility Principle is most emphasized, VIPER is the best suited architectural pattern. It splits the navigation logic to Routers, and network logic to Interactors. In order to depend on other frameworks, only Router's class from the module has to be exposed publicly and keep the remaining core functionality of the module can be hidden. 

## Dependencies
No 3rd party frameworks are used for this app. It is entirely built using native frameworks.

## APIs
- The app uses free API from `CoinGecko` for fetching historical and current prices of bitcoin. Endpoint: `https://api.coingecko.com/api/v3`
- It also uses another free API from `ExchangeRates` to get the forex rates on a given day. Endpoint: `http://api.exchangeratesapi.io/v1/`
