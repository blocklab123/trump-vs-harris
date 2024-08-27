import "@stdlib/deploy";
import "@stdlib/ownable";
import "@stdlib/stoppable";

contract TrumpVsHarris with Deployable, OwnableTransferable, Resumable {
    // Empty init() function is present by default in all Tact contracts
    // since v1.3.0, so the following may be omitted:
    //

    owner: Address; // owner of the contract
    operator: Address;
    // operators: map<Address, Int>; // store a list of operators, this is not implemented for now to prevent troubles
    stopped: Bool; // The Resumable trait requires you to add this exact state variable
    const FIRST_PRICE: Int = ton("0.01"); //10000000 7zeros
    totalTonInTrump: Int as coins;
    totalTonInHarris: Int as coins;
    const GAS_THRESHOLD: Int = ton("0.1"); // deducting the GAS fee
    const MESSAGING_FEE: Int = ton("0.02"); // deducting the GAS fee

    init(){
        self.owner = sender();
        self.operator = sender();
        self.stopped = false;
        self.totalTonInTrump = 0;
        self.totalTonInHarris = 0;
    }

    receive("trump"){
        self.vote(1);
    }

    receive("harris"){
        self.vote(2);
    }

    fun vote(votingFor: Int) {
        let ctx: Context = context();
        self.requireNotStopped();
        let price: Int = self.priceForTrump();
        if (votingFor == 2) {
            //vote for harris
            price = self.priceForHarris();
        }
        let gastAfterValue = ctx.value - self.GAS_THRESHOLD;
        require(gastAfterValue >= price, "not enough ton to vote");
        let numberOfVote = gastAfterValue / price;
    }

    get fun priceForTrump(): Int {
        let target: Int = self.totalTonInTrump / 1000000000;
        let digit: Int = 1;
        if (target <= 100) {
            digit = 1;
        }
        while (target > 100) {
            digit = digit + 1;
            target = target / 10;
        }
        let multiplier: Int = digit;
        if (digit > 6) {
            multiplier = digit * pow(10, digit - 7);
        }
        return (self.FIRST_PRICE + (self.totalTonInTrump / 1000000)) * multiplier;
    }

    get fun priceForHarris(): Int {
        let target: Int = self.totalTonInHarris / 1000000000;
        let digit: Int = 1;
        if (target <= 100) {
            digit = 1;
        }
        while (target > 100) {
            digit = digit + 1;
            target = target / 10;
        }
        let multiplier: Int = digit;
        if (digit > 6) {
            multiplier = digit * pow(10, digit - 7);
        }
        return (self.FIRST_PRICE + (self.totalTonInHarris / 1000000)) * multiplier;
    }
}