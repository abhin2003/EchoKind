# EcoKind

A privacy-first content moderation SDK powered by decentralized LLMs on the Internet Computer. Detect and improve toxic messages in real-time with secure, lightweight integration.

> ⚠️ **Authorization required:** Valid project key needed for all features.

## Features

- Real-time content moderation with toxicity detection
- Privacy-preserving AI on decentralized infrastructure  
- Message improvement suggestions
- Easy integration with existing systems
- TypeScript support

## Quick Start

### Installation

```bash
npm install ecokind-moderation-sdk
```

### Usage

```javascript
const EcoKindClient = require('ecokind-moderation-sdk');

async function main() {
  const client = new EcoKindClient();
  await client.initialize();
  await client.authorize('myproject', 'myproject-key');

  const level = await client.harassmentLevel('You are dumb!');
  const improved = await client.suggestImprovedMessage('You are dumb!');
  
  console.log('Toxicity Level:', level); // 'Low', 'Moderate', or 'High'
  console.log('Improved Message:', improved);
}

main().catch(console.error);
```

## Development Setup

### Local Development

```bash
# Start local IC replica
dfx start --background

# Deploy canisters
dfx deploy

# Generate interfaces
npm run generate

# Start frontend (if applicable)
npm start
```

### Local SDK Configuration

```javascript
const client = new EcoKindClient('local-canister-id', {
  host: 'http://localhost:8000',
  isLocal: true
});
```

## Core API Methods

```javascript
// Authorization (required first)
await client.authorize(project, key);

// Content moderation
await client.harassmentLevel(content);           // Returns: 'Low'|'Moderate'|'High'
await client.suggestImprovedMessage(content);    // Returns: improved message

// Additional utility methods available

// Validation
await client.validateKey(project, key);
```

## Message Object

```javascript
{
  sender: "user1-address",
  receiver: "user2-address", 
  content: "Hello there!",
  timestamp: 1640995200000
}
```

## Error Handling

```javascript
try {
  await client.sendMessage('user1', 'user2', 'Hello!');
} catch (error) {
  console.error('Authorization or network error:', error);
}
```

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/name`)
3. Commit changes (`git commit -m 'Add feature'`)
4. Push branch (`git push origin feature/name`)
5. Open Pull Request

## Support

- [Internet Computer Docs](https://internetcomputer.org/docs/)
- [DFINITY Forum](https://forum.dfinity.org/)
- GitHub Issues

## License

MIT License - see LICENSE file for details.

---

**Built on the Internet Computer**