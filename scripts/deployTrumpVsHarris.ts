import { toNano } from '@ton/core';
import { TrumpVsHarris } from '../wrappers/TrumpVsHarris';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const trumpVsHarris = provider.open(await TrumpVsHarris.fromInit());

    await trumpVsHarris.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(trumpVsHarris.address);

    // run methods on `trumpVsHarris`
}
