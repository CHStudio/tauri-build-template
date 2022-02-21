import {spawn, spawnSync} from "child_process";
import * as path from "path";

// keep track of the `tauri-driver` child process
let tauriDriver;

exports.config = {
  specs: [
      "./test/specs/**/*.ts",
  ],
  maxInstances: 1,
  capabilities: [
    {
      maxInstances: 1,
      "tauri:options": {
        application: "../../src-tauri/target/release/ch-desktop",
      },
      'goog:chromeOptions': {
        args: [
          '--no-sandbox',
          '--disable-infobars',
          '--headless',
          '--disable-gpu',
          '--window-size=1440,735'
        ],
      },
      'moz:firefoxOptions': {
        args: ['-headless']
      },
    },
  ],
  reporters: ["spec"],
  framework: "mocha",
  mochaOpts: {
    ui: "bdd",
    timeout: 60000,
  },
  headless: true,

  // Level of logging verbosity: trace | debug | info | warn | error | silent
  logLevel: 'trace',

  // Set directory to store all logs into
  outputDir: 'test_logs',

  autoCompileOpts: {
    autoCompile: true,
    // see https://github.com/TypeStrong/ts-node#cli-and-programmatic-options
    // for all available options
    tsNodeOpts: {
      transpileOnly: true,
      project: 'tsconfig.json'
    },
    // tsconfig-paths is only used if "tsConfigPathsOpts" are provided, if you
    // do please make sure "tsconfig-paths" is installed as dependency
    tsConfigPathsOpts: {
      baseUrl: './'
    }
  },

  // ensure the rust project is built since we expect this binary to exist for the webdriver sessions
  onPrepare: () => spawnSync("cargo", ["build", "--release"]),

  // ensure we are running `tauri-driver` before the session starts so that we can proxy the webdriver requests
  beforeSession: function () {
    const tauriDriverPath = path.resolve(process.cwd(), '../../bin/tauri-driver');

    return tauriDriver = spawn(
        tauriDriverPath,
        [],
        {stdio: [null, process.stdout, process.stderr]}
    );
  },

  // clean up the `tauri-driver` process we spawned at the start of the session
  afterSession: () => tauriDriver.kill(),
};

