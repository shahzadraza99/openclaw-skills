# OpenClaw Skills

A collection of skills for [OpenClaw](https://github.com/openclaw) — the open-source AI agent platform.

## Available Skills

### 🚀 Go High Level (GHL)

**Path**: `skills/gohighlevel/`

Comprehensive skill for integrating with the [Go High Level](https://www.gohighlevel.com/) CRM platform via its REST API v2 and official Python SDK.

#### Features

- **39 sections** covering 200+ API endpoints
- **Official Python SDK** (`gohighlevel-api-client`) — async, auto token refresh, webhook middleware
- **Full CRM coverage**: Contacts, Conversations, Calendars, Opportunities, Payments, Invoices
- **Marketing tools**: Funnels, Forms, Surveys, Social Planner, Blogs, Courses
- **Platform management**: Locations, Users, Companies, Custom Fields, Webhooks, Triggers
- **Agency tools**: Snapshots, SaaS API, Reputation Management
- **Helper scripts**: Bash API wrapper + Python SDK examples
- **Self-updating**: Instructions to keep the skill current with latest API changes

#### Quick Start

```bash
# Install the official Python SDK
pip install gohighlevel-api-client
```

```python
import asyncio
from highlevel import HighLevel

async def main():
    client = HighLevel(
        client_id="your_client_id",
        client_secret="your_client_secret",
    )
    contacts = await client.contacts.search_contacts_advanced({
        "locationId": "YOUR_LOCATION_ID",
        "pageLimit": 5,
    })
    print(contacts)

asyncio.run(main())
```

#### Skill Structure

```
skills/gohighlevel/
├── SKILL.md                          # Main skill file (1,684 lines)
├── scripts/
│   └── ghl_api.sh                    # Bash helper functions
└── examples/
    ├── sdk_python_demo.py            # Python SDK demo
    ├── sdk_webhook_server.py         # FastAPI webhook server
    ├── contact_management.sh         # Contact CRUD examples
    ├── appointment_booking.sh        # Calendar & booking flow
    ├── pipeline_automation.sh        # Pipeline management
    └── webhook_setup.sh              # Webhook configuration
```

## Contributing

To add a new skill:

1. Create a directory under `skills/` with your skill name
2. Add a `SKILL.md` file following the OpenClaw skill specification
3. Include helper scripts in `scripts/` and examples in `examples/`
4. Submit a pull request

## License

MIT
