import FungibleToken from 0x05
import NftToken from 0x05

pub fun main(account: Address) {

    // Borrow the public vault capability, specializing it for balance
    let publicVault = getAccount(account)
        .getCapability(/public/Vault)
        .borrow<&NftToken.Vault{FungibleToken.Balance}>()
        ?? panic("Unable to access the vault. Please check the setup.")

    log("Vault setup verified successfully.")
}
