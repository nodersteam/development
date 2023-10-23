#!/bin/bash

request_tokens() {

    # Check Sync Status
    if [[ "$SYNC_STATUS" == "true" ]]; then
        echo ""
        echo "Your node is synchronizing. You won't be able to execute token requests until your node finishes synchronization."
        echo "After synchronization is complete, you will be able to interact with commands to request tokens."
        echo ""
        read -p "Press any key to continue..."
        return
    fi

    if [[ -z "$WALLET_ADDRESS" ]]; then
        WALLET_ADDRESS=$(namadac balance --owner $WALLET_NAME --token NAM | grep "No nam balance found" | awk '{print $NF}')
        if [[ ! -z "$WALLET_ADDRESS" ]]; then
            sed -i '/export WALLET_ADDRESS=/d' $HOME/.bash_profile
            echo "export WALLET_ADDRESS=\"$WALLET_ADDRESS\"" >> $HOME/.bash_profile
            source $HOME/.bash_profile
        fi
    fi

    while true; do
        echo " "
        echo "To request tokens, please visit the following website"
        echo " "
        echo "https://faucet.heliax.click/"
        echo " "
        echo "and request tokens to your address: "
        echo "$WALLET_ADDRESS"
        echo " "
        echo "1. Return to Main Menu"
        
        if [[ ! -z "$VALIDATOR_ADDRESS" && ! -z "$MONIKER" ]]; then
            echo "2. Show Validator Information"
        fi

        read -p "Enter your choice: " faucet_choice
        
        case $faucet_choice in
            1)
                break
                ;;
            2)
                if [[ ! -z "$VALIDATOR_ADDRESS" && ! -z "$MONIKER" ]]; then
                    echo "Validator Information:"
                    echo "Moniker: $MONIKER"
                    echo "Validator Address: $VALIDATOR_ADDRESS"
                    read -p "Press any key to continue..."
                else
                    echo "Validator address or moniker is not set."
                    read -p "Press any key to continue..."
                fi
                ;;
            *)
                echo "Invalid choice!"
                read -p "Press any key to continue..."
                ;;
        esac
    done
}

request_tokens
