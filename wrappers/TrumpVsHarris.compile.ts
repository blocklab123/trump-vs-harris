import { CompilerConfig } from '@ton/blueprint';

export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/trump_vs_harris.tact',
    options: {
        debug: true,
    },
};
