import FungibleToken from 0x05
import NftToken from 0x05

transaction(receiverAccount: Address, amount: UFix64) {

    // Define references for the sender's and receiver's vaults
    let signerVault: &NftToken.Vault
    let receiverVault: &NftToken.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        // Borrow references and handle errors
        self.signerVault = acct.borrow<&NftToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Sender's vault not found")

        self.receiverVault = getAccount(receiverAccount)
            .getCapability(/public/Vault)
            .borrow<&NftToken.Vault{FungibleToken.Receiver}>()
            ?? panic("Receiver's vault not found")
    }

    execute {
        // Withdraw tokens from the sender's vault and deposit them into the receiver's vault
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: amount))
        log("Tokens successfully transferred from sender to receiver")
    }
}