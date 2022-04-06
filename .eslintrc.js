module.exports = {
    root: true,
    env: {
        node: true,
    },
    extends: ['plugin:vue/vue3-recommended', 'eslint:recommended', 'plugin:prettier-vue/recommended', 'prettier'],
    parserOptions: {
        parser: '@babel/eslint-parser',
    },
    plugins: ['vue', 'prettier'],
    rules: {
        'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
        'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
        'prettier/prettier': [
            'warn',
            {
                endOfLine: 'auto',
            },
        ],
        'prettier-vue/prettier': [
            'warn',
            {
                endOfLine: 'auto',
            },
        ],
    },
    overrides: [
        {
            files: [
                '**/__tests__/*.{j,t}s?(x)',
                '**/tests/unit/**/*.spec.{j,t}s?(x)',
                '**/unit-test/**/*.spec.{j,t}s?(x)',
            ],
            env: {
                jest: true,
            },
        },
    ],
};
