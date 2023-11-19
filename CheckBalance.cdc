import FungibleToken from 0x05
import NftToken from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &NftToken.Vault{FungibleToken.Balance, 
    FungibleToken.Receiver, NftToken.VaultInterface}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&NftToken.Vault{FungibleToken.Balance, 
            FungibleToken.Receiver, NftToken.VaultInterface}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- NftToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&NftToken.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver, NftToken.VaultInterface}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created and linked")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &NftToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&NftToken.Vault{FungibleToken.Balance}>()
        log("Balance of the new vault: ")
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &NftToken.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver, NftToken.VaultInterface} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&NftToken.Vault{FungibleToken.Balance, 
                FungibleToken.Receiver, NftToken.VaultInterface}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if NftToken.vaults.contains(checkVault.uuid) {     
            log("Balance of the existing vault:")       
            log(publicVault?.balance)
            log("This is a NftToken vault")
        } else {
            log("This is not a NftToken vault")
        }
    }
}
