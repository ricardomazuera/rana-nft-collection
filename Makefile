# Loading environment variables 
ifeq (,$(wildcard .env))
  $(error "The file .env doesn't exists")
else
  include .env
  export
endif

# variables
RPC_URL=http://localhost:8545
CAST_WALLET_PK_NAME=localPK
SENDER_ADDRESS=0x90f79bf6eb2c4f870365e785982e1f101e93b906
CONTRACT_ADDRESS=0x057ef64E23666F000b34aE31332854aCBd1c8544
SEPOLIA_WALLET_PK_NAME=sepoliaKey
SEPOLIA_SENDER_ADDRESS=0x589605619b607c9ebf8520ce75d3007f4dafd3d9

install-dependencies:
	@echo "Installing dependencies..."
	forge install OpenZeppelin/openzeppelin-contracts --no-commit


NETWORK_ARGS := --rpc-url $(RPC_URL) --account $(CAST_WALLET_PK_NAME) --sender $(SENDER_ADDRESS) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(SEPOLIA_WALLET_PK_NAME) --sender $(SEPOLIA_SENDER_ADDRESS) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@echo "Deploying contract"
	@forge script script/DeployBasicNft.s.sol:DeployBasicNft $(NETWORK_ARGS)

mint:
	@echo "Minting NFT"
	@forge script script/Interactions.s.sol:MintBasicNft $(NETWORK_ARGS)

run-unittests:
	@echo "Formatting code..."
	forge fmt
	@echo "Running tests"
	forge coverage
	@echo "Exporting coverage report"
	forge coverage --report debug > coverage.txt

verify-contract:
	@echo "Verifying contract"
	forge verify-contract 0x4A0F52080A880A95cF97a1ad590fd7b346b9927F script/DeployBasicNft.s.sol:DeployBasicNft --chain-id 11155111 --compiler-version 0.8.20
