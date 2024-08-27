import { toNano } from '@ton/core';
import { HarrisWallet } from '../wrappers/HarrisWallet';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const harrisWallet = provider.open(await HarrisWallet.fromInit());

    await harrisWallet.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(harrisWallet.address);

    // run methods on `harrisWallet`
}
