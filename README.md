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

### Lints and fixes files

```
yarn lint
yarn pretty
```

### Process to build for release/production

For development, `yarn tauri:serve` will do what you need. For building, however, we do not recommend using `yarn tauri:build`, but instead use another method.

Since it is sometimes important to separate concerns between Rust and Node.js ecosystems, we recommend you do the building in **two processes**:

1. Run `yarn build` to build your Vue app as static files in the `dist/` directory.
2. Run `./bin/tauri build` (`.\bin\tauri.exe build` on Windows) to create the final binary in the `src-tauri/target/release/` directory.

> You could still use `yarn tauri:build`, but somehow it does not build the app the same way (there are some errors, feel free to drop an issue if you want to know more), and it combines a nodejs-installed version of the Tauri CLI binary, while we could just install it with Cargo.
> This breaks separation of concerns, so we do not recommend it.
