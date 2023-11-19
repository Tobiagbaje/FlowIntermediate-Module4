import FungibleToken from 0x05
import NftToken from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the NftToken Minter reference
        let minter = signer.borrow<&NftToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not the NftToken minter")
        
        // Borrow the receiver's NftToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&NftToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your NftToken Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's NftToken Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("NftToken minted and deposited successfully")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}