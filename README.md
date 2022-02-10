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

```
yarn install
yarn tauri deps install
```

### Compiles and hot-reloads for development

```
yarn serve # Frontend
yarn tauri dev # Backend
```

### Compiles and minifies for production

```
yarn build # Build frontend into the "dist/" directory
yarn tauri build # Builds backend in the src-tauri/target/release directory
```

### Lints and fixes files

```
yarn lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
