# MAD Weatherize

## Contributors

- **Daniel Imran (2113649)** - _Dashboard Page and Other Pages integration_ - [Daniel](https://github.com/Ken69420)
- **Haziq Yusof (2123841)** - _Authentication pages_ - [Haziq](https://github.com/Hziqyusof)
- **Aziz (2029443)** - _Profile and personalization page_ - [Aziz](https://github.com/kvcli)

## Demo

Check out the video demo of the application and for more in depth explaination [here](https://youtu.be/jhYDKPUvovs).

MAD Weatherize is a weather application designed to provide accurate weather information using the OpenWeatherMap One Call API. This application is specifically tested and optimized for Android devices, particularly on the Tiramisu Android version using the Pixel 8 emulator.

## Features

- **Real-time Weather Updates**: Get the latest weather information for your location.
- **7-Day Forecast**: View the weather forecast for the next 7 days.
- **Location-Based Weather**: Automatically fetches weather data based on your current location.

## Dependencies

- **Refer pubspec.yaml for the list of dependencies**

## Setup Instructions

1. **Clone the repository:**

   ```sh
   git clone https://github.com/yourusername/mad_weatherize.git
   cd mad_weatherize
   ```

2. **Install Flutter SDK:**
   Follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install) to install the Flutter SDK.

3. **Install dependencies:**

   ```sh
   flutter pub get
   ```

4. **Set up Firebase:**

   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add your Android app to the Firebase project.
   - Download the `google-services.json` file for Android and place it in the [app](http://_vscodecontentref_/1) directory.

5. **Configure OpenWeatherMap API:**

   - Sign up for an API key at [OpenWeatherMap](https://openweathermap.org/api).
   - Add your API key to the application by updating the relevant configuration file or environment variable.

6. **Run the application:**
   ```sh
   flutter run
   ```

## Testing

This application has been tested on the following configuration:

- **Android Version**: Tiramisu
- **Emulator**: Pixel 8

## Acknowledgements

- [OpenWeatherMap](https://openweathermap.org/) for providing the weather API.
- [Flutter](https://flutter.dev/) for the amazing framework.
