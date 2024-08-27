import { toNano } from '@ton/core';
import { TrumpWallet } from '../wrappers/TrumpWallet';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const trumpWallet = provider.open(await TrumpWallet.fromInit());

    await trumpWallet.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(trumpWallet.address);

    // run methods on `trumpWallet`
}
