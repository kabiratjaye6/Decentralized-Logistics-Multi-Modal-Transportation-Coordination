# Decentralized Logistics Multi-Modal Transportation Coordination

A comprehensive blockchain-based system for coordinating multi-modal transportation logistics using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized platform for managing complex logistics operations involving multiple transportation modes, coordinators, and documentation requirements. It optimizes costs, coordinates transfers, and ensures compliance through smart contract automation.

## Features

### 🚛 Transportation Coordinator Verification
- Coordinator registration and verification system
- Rating and performance tracking
- Authorization management for logistics operations

### 🔄 Mode Selection Contract
- Intelligent transportation mode selection
- Multi-criteria optimization (cost, speed, environmental impact)
- Route and capacity management

### 🔗 Transfer Coordination Contract
- Seamless intermodal transfer coordination
- Transfer point management
- Real-time status tracking

### 📋 Documentation Management Contract
- Secure document storage and verification
- Access control and permissions
- Compliance tracking and validation

### 💰 Cost Optimization Contract
- Dynamic cost calculation
- Multi-modal route optimization
- Real-time cost factor updates

## Smart Contracts

### 1. Coordinator Verification (\`coordinator-verification.clar\`)
Manages the registration, verification, and rating of logistics coordinators.

**Key Functions:**
- \`register-coordinator\`: Register new logistics coordinator
- \`verify-coordinator\`: Verify coordinator credentials (admin only)
- \`update-rating\`: Update coordinator performance rating
- \`is-verified\`: Check coordinator verification status

### 2. Mode Selection (\`mode-selection.clar\`)
Handles optimal transportation mode selection based on various criteria.

**Key Functions:**
- \`add-route\`: Add new transportation route
- \`select-optimal-mode\`: Select best transportation mode
- \`get-mode\`: Retrieve transportation mode details

**Transportation Modes:**
- Truck: Fast, flexible, medium capacity
- Rail: Cost-effective, high capacity, eco-friendly
- Ship: Lowest cost, highest capacity, slow
- Air: Fastest, expensive, medium capacity

### 3. Transfer Coordination (\`transfer-coordination.clar\`)
Coordinates transfers between different transportation modes.

**Key Functions:**
- \`schedule-transfer\`: Schedule intermodal transfer
- \`update-transfer-status\`: Update transfer progress
- \`complete-transfer\`: Mark transfer as completed
- \`add-transfer-point\`: Add new transfer hub

### 4. Documentation Management (\`documentation-management.clar\`)
Manages shipping documentation and compliance requirements.

**Key Functions:**
- \`create-document\`: Create new shipping document
- \`grant-access\`: Grant document access permissions
- \`verify-document\`: Verify document authenticity
- \`update-document-status\`: Update document status

**Document Types:**
- Bill of Lading
- Customs Declaration
- Insurance Certificate

### 5. Cost Optimization (\`cost-optimization.clar\`)
Optimizes transportation costs across routes and modes.

**Key Functions:**
- \`calculate-route-cost\`: Calculate cost for specific route/mode
- \`optimize-transportation\`: Find optimal route and mode combination
- \`calculate-multimodal-cost\`: Calculate total cost for complex journeys

## Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd decentralized-logistics
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## Usage

### Registering as a Coordinator

\`\`\`clarity
(contract-call? .coordinator-verification register-coordinator "My Logistics Co" "LIC123456")
\`\`\`

### Selecting Optimal Transportation Mode

\`\`\`clarity
;; Priority: 1=cost, 2=speed, 3=environment
(contract-call? .mode-selection select-optimal-mode u1 u15000 u1)
\`\`\`

### Scheduling an Intermodal Transfer

\`\`\`clarity
(contract-call? .transfer-coordination schedule-transfer u1001 u1 u2 "Central Hub" u1000 u500)
\`\`\`

### Creating Shipping Documentation

\`\`\`clarity
(contract-call? .documentation-management create-document u1001 "bill-of-lading" 0x1234... none "Standard BOL")
\`\`\`

### Optimizing Transportation Costs

\`\`\`clarity
(contract-call? .cost-optimization optimize-transportation "New York" "Los Angeles" u15000 (list u1 u2) (list u1 u2 u4))
\`\`\`

## Testing

The project includes comprehensive tests for all smart contracts using Vitest:

\`\`\`bash
npm test
\`\`\`

Test files are located in the \`tests/\` directory and cover:
- Coordinator registration and verification
- Transportation mode selection logic
- Transfer coordination workflows
- Document management and access control
- Cost optimization algorithms

## Architecture

### Data Flow

1. **Coordinator Registration**: Logistics providers register and get verified
2. **Route Planning**: System selects optimal transportation modes
3. **Transfer Coordination**: Manages handoffs between different transport modes
4. **Documentation**: Creates and manages required shipping documents
5. **Cost Optimization**: Continuously optimizes costs across the network

### Security Features

- **Access Control**: Role-based permissions for different operations
- **Document Verification**: Cryptographic hash verification for documents
- **Coordinator Verification**: Multi-step verification process for coordinators
- **Immutable Records**: All transactions recorded on blockchain

## Cost Factors

The system considers multiple cost factors:

- **Base Costs**: Fixed costs per transportation mode
- **Distance Costs**: Variable costs based on distance
- **Weight Costs**: Costs based on cargo weight
- **Fuel Surcharges**: Dynamic fuel cost adjustments
- **Handling Fees**: Transfer and handling costs

## Environmental Considerations

Each transportation mode has an environmental score:
- Rail: 90/100 (most eco-friendly)
- Ship: 85/100
- Truck: 60/100
- Air: 40/100 (least eco-friendly)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.

## Roadmap

- [ ] Integration with IoT devices for real-time tracking
- [ ] Machine learning for predictive cost optimization
- [ ] Mobile app for coordinators
- [ ] Integration with existing ERP systems
- [ ] Multi-chain support
  \`\`\`

Finally, let's create the PR details file:
