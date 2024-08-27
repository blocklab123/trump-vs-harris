import "@stdlib/deploy";

contract HarrisWallet with Deployable {
    // Empty init() function is present by default in all Tact contracts
    // since v1.3.0, so the following may be omitted:
    //
    const MESSAGING_FEE: Int = ton("0.02"); // deducting the GAS fee
    init(){}

    receive(msg: TokenTransferInternal){
        let ctx: Context = context(); // Check sender
        // this function can be called by either parents or other wallet
        if (ctx.sender != self.parent) {
            let init: StateInit = self.getShareWalletInit(msg.from);
            require(contractAddress(init) == ctx.sender, "Invalid sender!");
            require(!self.walletLocked, "wallet is locked"); // you can still buy but you cannot take transfer from outsider
        }
        self.balance = self.balance + msg.amount;
        //update the claimed time every time when new share arrived
        //so same share cannot be claimed multiple time
        self.claimedTime = now();
        // notify the new owner of JettonToken that the transfer is complete
        send(SendParameters{
                to: self.owner,
                value: self.MESSAGING_FEE,
                mode: SendPayGasSeparately + SendIgnoreErrors,
                bounce: false,
                body: TokenNotification{amount: msg.amount, from: msg.from}.toCell()
            }
        );
        // Cashback to the original Sender
        let msgValue: Int = ctx.value - self.MESSAGING_FEE;
        if (msg.from != null && msgValue > 0) {
            send(SendParameters{
                    to: msg.from,
                    value: msgValue,
                    bounce: false,
                    body: "Cashback".asComment(),
                    mode: SendIgnoreErrors
                }
            );
        }
    }
}