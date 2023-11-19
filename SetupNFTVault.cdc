// Import FungibleToken and NftToken contracts from version 0x05
import FungibleToken from 0x05
import NftToken from 0x05

// Create Nft Token Vault Transaction
transaction () {

    // Define references
    let userVault: &NftToken.Vault{FungibleToken.Balance, 
        FungibleToken.Provider, 
        FungibleToken.Receiver, 
        NftToken.VaultInterface}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow the vault capability and set the account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&NftToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, NftToken.VaultInterface}>()
        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- NftToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&NftToken.Vault{FungibleToken.Balance, 
                FungibleToken.Provider, 
                FungibleToken.Receiver, 
                NftToken.VaultInterface}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}