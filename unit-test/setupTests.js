import { randomFillSync } from 'crypto';

// jsdom doesn't come with a WebCrypto implementation
window.crypto = {
    getRandomValues: function (buffer) {
        return randomFillSync(buffer);
    },
};
