# ch-desktop

## Requirements

* [Rust](https://www.rust-lang.org/tools/install)
* [Node.js](https://nodejs.org/en/download/)
* [Yarn](https://yarnpkg.com/getting-started/install) (preferred by the Tauri team, so expect better compatibility)
* For Linux users:
    * Follow [this guide](https://tauri.studio/docs/get-started/setup-linux#1-system-dependencies) to install the **system dependencies** that are mandatory. 
* For Windows users:
    * [Webview2](https://developer.microsoft.com/en-us/microsoft-edge/webview2/#download-section)
* For MacOS users:
    * XCode
    * The GNU C Compiler, installable via `brew install gcc`

## Project setup

### Install

```
yarn install
```

> Don't need to install Rust dependencies, since running `cargo` commands like `cargo run` will automatically download and compile dependencies.

### Run the app in dev mode

```
yarn tauri:serve
```

> Since the project uses `vue-cli-plugin-tauri`, running `tauri:serve` will automatically run `yarn serve` beforehand, so the HTTP server is available when the Tauri apps is running. 

### Compile for production

```
yarn tauri:build
```

> This command builds the app in the `src-tauri/target/release/` directory.

### Lints and fixes files

```
yarn lint
```
