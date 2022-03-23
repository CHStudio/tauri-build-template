module.exports = {
    preset: '@vue/cli-plugin-unit-jest',
    testMatch: ['<rootDir>/unit-test/**/*.spec.(ts|tsx|js)'],
    testURL: 'http://localhost',
    reporters: ['default'],
    transformIgnorePatterns: ['/node_modules/(?!(@tauri-apps)/)', '\\.pnp\\.[^\\/]+$'],
    setupFiles: ['<rootDir>/unit-test/setupTests.js'],
    globals: {
        'vue-jest': {
            compilerOptions: {},
        },
    },
};
