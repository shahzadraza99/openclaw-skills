---
name: gohighlevel
description: Comprehensive skill for integrating with the Go High Level (GHL) CRM platform via its REST API v2 and official Python SDK. Covers contacts, conversations, calendars, opportunities, payments, invoices, workflows, funnels, forms, surveys, social planner, courses, memberships, media, companies, custom fields, snapshots, SaaS, reputation management, and more.
version: 1.1.0
requires:
  env:
    - GHL_API_KEY: "Go High Level API Bearer Token (OAuth 2.0 access token or Private Integration Token)"
    - GHL_LOCATION_ID: "The Location/Sub-Account ID for location-scoped API calls"
    - GHL_CLIENT_ID: "(Optional) OAuth Client ID for SDK-based integrations"
    - GHL_CLIENT_SECRET: "(Optional) OAuth Client Secret for SDK-based integrations"
  bins:
    - curl
    - python3
    - pip
---

# Go High Level (GHL) Platform Skill

> **Self-Updating Policy**: If a feature or endpoint referenced in this skill is not working or returns an error, search the internet for the latest GHL API v2 documentation, verify the correct endpoint/payload, and update this skill accordingly. Always check the [official docs](https://marketplace.gohighlevel.com/docs/) for the most current information.

---

## Table of Contents

1.  [Overview & Authentication](#1-overview--authentication)
2.  [Official Python SDK (Recommended)](#2-official-python-sdk-recommended)
3.  [Base URL & Headers](#3-base-url--headers)
4.  [Rate Limits](#4-rate-limits)
5.  [Contacts](#5-contacts)
6.  [Conversations](#6-conversations)
7.  [Calendars & Appointments](#7-calendars--appointments)
8.  [Opportunities (Pipelines & Deals)](#8-opportunities-pipelines--deals)
9.  [Payments](#9-payments)
10. [Invoices](#10-invoices)
11. [Workflows](#11-workflows)
12. [Funnels & Websites](#12-funnels--websites)
13. [Forms](#13-forms)
14. [Surveys](#14-surveys)
15. [Social Planner](#15-social-planner)
16. [Courses & Memberships](#16-courses--memberships)
17. [Media Storage](#17-media-storage)
18. [Companies](#18-companies)
19. [Custom Fields](#19-custom-fields)
20. [Custom Values](#20-custom-values)
21. [Businesses](#21-businesses)
22. [Users](#22-users)
23. [Locations (Sub-Accounts)](#23-locations-sub-accounts)
24. [Associations](#24-associations)
25. [Snapshots](#25-snapshots)
26. [SaaS API](#26-saas-api)
27. [Webhooks](#27-webhooks)
28. [Triggers](#28-triggers)
29. [Blogs](#29-blogs)
30. [Documents & Contracts](#30-documents--contracts)
31. [Reputation Management & Reviews](#31-reputation-management--reviews)
32. [Email / SMS / Calls](#32-email--sms--calls)
33. [Links](#33-links)
34. [Tags](#34-tags)
35. [Notes & Tasks](#35-notes--tasks)
36. [Products & Prices](#36-products--prices)
37. [Object Records (Custom Objects)](#37-object-records-custom-objects)
38. [OAuth & Marketplace Apps](#38-oauth--marketplace-apps)
39. [Self-Update Instructions](#39-self-update-instructions)

---

## 1. Overview & Authentication

Go High Level (GHL) is an all-in-one CRM platform for agencies and businesses. The **API v2** uses **OAuth 2.0** exclusively for authentication.

### Authentication Methods

| Method | Use Case |
|---|---|
| **Marketplace App (OAuth 2.0)** | Public/private apps distributed via the GHL Marketplace |
| **Private Integration Token** | Single-account integrations, personal automations |

### OAuth 2.0 Flow

1. Register your app at [marketplace.gohighlevel.com](https://marketplace.gohighlevel.com)
2. Redirect users to the authorization URL
3. Exchange the authorization code for access and refresh tokens
4. Use the access token as a Bearer token in API calls
5. Refresh tokens before they expire (tokens last ~24 hours)

**Authorization URL:**
```
https://marketplace.gohighlevel.com/oauth/chooselocation
  ?response_type=code
  &redirect_uri=YOUR_REDIRECT_URI
  &client_id=YOUR_CLIENT_ID
  &scope=SCOPES
```

**Token Exchange:**
```bash
curl -X POST https://services.leadconnectorhq.com/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "grant_type=authorization_code" \
  -d "code=AUTH_CODE" \
  -d "redirect_uri=YOUR_REDIRECT_URI"
```

**Token Refresh:**
```bash
curl -X POST https://services.leadconnectorhq.com/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=YOUR_REFRESH_TOKEN"
```

### Available OAuth Scopes

| Scope | Description |
|---|---|
| `contacts.readonly` | Read contacts |
| `contacts.write` | Create/update contacts |
| `conversations.readonly` | Read conversations |
| `conversations.write` | Send messages |
| `conversations/message.readonly` | Read messages |
| `conversations/message.write` | Send messages |
| `calendars.readonly` | Read calendars |
| `calendars.write` | Manage calendars |
| `calendars/events.readonly` | Read calendar events |
| `calendars/events.write` | Manage calendar events |
| `opportunities.readonly` | Read opportunities |
| `opportunities.write` | Manage opportunities |
| `payments.readonly` | Read payments |
| `payments.write` | Process payments |
| `invoices.readonly` | Read invoices |
| `invoices.write` | Manage invoices |
| `medias.readonly` | Read media files |
| `medias.write` | Upload media files |
| `locations.readonly` | Read locations |
| `locations.write` | Manage locations |
| `companies.readonly` | Read companies |
| `companies.write` | Manage companies |
| `workflows.readonly` | Read workflows |
| `forms.readonly` | Read forms |
| `forms.write` | Manage forms |
| `surveys.readonly` | Read surveys |
| `funnels.readonly` | Read funnels |
| `funnels.write` | Manage funnels |
| `blogs.readonly` | Read blogs |
| `blogs.write` | Manage blogs |
| `businesses.readonly` | Read businesses |
| `businesses.write` | Manage businesses |
| `users.readonly` | Read users |
| `users.write` | Manage users |
| `snapshots.readonly` | Read snapshots |
| `courses.readonly` | Read courses |
| `courses.write` | Manage courses |
| `socialplanner/post.readonly` | Read social posts |
| `socialplanner/post.write` | Manage social posts |
| `products.readonly` | Read products |
| `products.write` | Manage products |
| `products/prices.readonly` | Read prices |
| `products/prices.write` | Manage prices |

---

## 2. Official Python SDK (Recommended)

> **Prefer the Python SDK over raw curl/HTTP calls.** GHL publishes an official async Python client that handles OAuth token rotation, webhook signature validation, and provides typed service methods for every endpoint.

### Installation

```bash
# pip
pip install gohighlevel-api-client

# poetry
poetry add gohighlevel-api-client

# pipenv
pipenv install gohighlevel-api-client
```

**Requires**: Python 3.8+

### Quick Start — Initialize Client

```python
from highlevel import HighLevel

client = HighLevel(
    client_id="your_client_id",
    client_secret="your_client_secret",
)
```

### Make an API Call (Async)

The SDK is **async-first**. Wrap your logic in `asyncio.run()` when not already inside an async framework:

```python
import asyncio
from highlevel import HighLevel

async def main():
    client = HighLevel(
        client_id="your_client_id",
        client_secret="your_client_secret",
    )

    # Search contacts
    response = await client.contacts.search_contacts_advanced({
        "locationId": "YOUR_LOCATION_ID",
        "pageLimit": 5,
    })
    print(response)

    # Get calendars
    calendars = await client.calendars.get_calendars({
        "locationId": "YOUR_LOCATION_ID",
    })
    print(calendars)

    # Create an opportunity
    opp = await client.opportunities.create_opportunity({
        "pipelineId": "PIPELINE_ID",
        "locationId": "YOUR_LOCATION_ID",
        "name": "New Deal",
        "status": "open",
        "contactId": "CONTACT_ID",
    })
    print(opp)

asyncio.run(main())
```

### Session Storage (Token Persistence)

Use in-memory storage for local testing or swap in MongoDB/Redis for production:

```python
from highlevel import HighLevel
from highlevel.storage import MongoDBSessionStorage

storage = MongoDBSessionStorage(
    connection_string="mongodb://localhost:27017",
    database_name="ghl_sessions",
    collection_name="jwt_tokens",
)

client = HighLevel(
    client_id="your_client_id",
    client_secret="your_client_secret",
    session_storage=storage,
)
```

### Webhook Integration (Middleware)

The SDK provides webhook middleware that validates signatures, handles INSTALL/UNINSTALL events automatically, and keeps session storage synchronized:

```python
from highlevel import HighLevel

client = HighLevel(
    client_id="your_client_id",
    client_secret="your_client_secret",
)

webhook_middleware = client.webhooks.subscribe()

@app.post("/api/webhooks/ghl")
async def handle_ghl_webhook(request):
    await webhook_middleware(request)
    # Your custom webhook logic goes here
    return {"status": "success"}
```

### SDK Service Methods

The SDK exposes typed service namespaces matching the API modules:

| Service Namespace | Maps To |
|---|---|
| `client.contacts` | Contacts API |
| `client.conversations` | Conversations API |
| `client.calendars` | Calendars API |
| `client.opportunities` | Opportunities API |
| `client.payments` | Payments API |
| `client.invoices` | Invoices API |
| `client.workflows` | Workflows API |
| `client.funnels` | Funnels API |
| `client.forms` | Forms API |
| `client.surveys` | Surveys API |
| `client.social_media_posting` | Social Planner API |
| `client.courses` | Courses API |
| `client.medias` | Media Storage API |
| `client.companies` | Companies API |
| `client.custom_fields` | Custom Fields API |
| `client.custom_values` | Custom Values API |
| `client.businesses` | Businesses API |
| `client.users` | Users API |
| `client.locations` | Locations API |
| `client.associations` | Associations API |
| `client.snapshots` | Snapshots API |
| `client.webhooks` | Webhooks API |
| `client.products` | Products API |
| `client.blogs` | Blogs API |
| `client.oauth` | OAuth API |

### SDK Features

- ✅ **Auto token rotation** — refresh happens transparently once storage is configured
- ✅ **Webhook utilities** — signature validation + automatic INSTALL/UNINSTALL handling
- ✅ **Token for bulk installation** — generates tokens for each location where app is installed
- ✅ **Typed service methods** — IDE autocompletion for all API operations
- ✅ **Session storage adapters** — In-memory, MongoDB, Redis, or custom
- ✅ **Async-first** — Built on `asyncio` for high-performance

### SDK Resources

| Resource | URL |
|---|---|
| PyPI Package | [pypi.org/project/gohighlevel-api-client/](https://pypi.org/project/gohighlevel-api-client/) |
| GitHub Source | [github.com/GoHighLevel/highlevel-api-python](https://github.com/GoHighLevel/highlevel-api-python) |
| SDK Examples | [github.com/GoHighLevel/ghl-sdk-examples/tree/main/python](https://github.com/GoHighLevel/ghl-sdk-examples/tree/main/python) |
| Python SDK Guide | [marketplace.gohighlevel.com/docs/sdk/python](https://marketplace.gohighlevel.com/docs/sdk/python) |
| All SDKs Overview | [marketplace.gohighlevel.com/docs/sdk/GettingStartedSDK/](https://marketplace.gohighlevel.com/docs/sdk/GettingStartedSDK/) |

> **Also available**: Node.js SDK (`@gohighlevel/api-client` via npm) and PHP SDK (`gohighlevel/api-client` via Composer).

---

## 3. Base URL & Headers

**Base URL:**
```
https://services.leadconnectorhq.com
```

**Required Headers:**
```
Authorization: Bearer YOUR_ACCESS_TOKEN
Content-Type: application/json
Version: 2021-07-28
```

> **Note**: The `Version` header is required for all API calls. Use `2021-07-28` as the API version.

---

## 3. Rate Limits

| Limit Type | Value |
|---|---|
| **Burst Limit** | 100 requests per 10 seconds |
| **Daily Limit** | 200,000 requests per app per resource (Location or Company) |

Exceeding rate limits will return a `429 Too Many Requests` error. Implement exponential backoff.

---

## 4. Contacts

The CRM's core entity. Full CRUD operations for managing leads and customers.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/contacts/{contactId}` | Get a specific contact |
| `PUT` | `/contacts/{contactId}` | Update a contact |
| `DELETE` | `/contacts/{contactId}` | Delete a contact |
| `POST` | `/contacts/` | Create a new contact |
| `POST` | `/contacts/upsert` | Create or update contact (by email/phone) |
| `GET` | `/contacts/` | Search/list contacts |
| `GET` | `/contacts/business/{businessId}` | Get contacts by business |
| `POST` | `/contacts/{contactId}/tags` | Add tags to a contact |
| `DELETE` | `/contacts/{contactId}/tags` | Remove tags from a contact |
| `GET` | `/contacts/{contactId}/tasks` | Get contact tasks |
| `POST` | `/contacts/{contactId}/tasks` | Create a task for a contact |
| `GET` | `/contacts/{contactId}/notes` | Get contact notes |
| `POST` | `/contacts/{contactId}/notes` | Create a note for a contact |
| `GET` | `/contacts/{contactId}/appointments` | Get contact appointments |
| `GET` | `/contacts/{contactId}/campaigns` | Get contact campaigns |
| `POST` | `/contacts/{contactId}/workflow/{workflowId}` | Add contact to workflow |
| `DELETE` | `/contacts/{contactId}/workflow/{workflowId}` | Remove contact from workflow |

### Create Contact Example

```bash
curl -X POST https://services.leadconnectorhq.com/contacts/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "locationId": "'$GHL_LOCATION_ID'",
    "tags": ["new-lead", "website"],
    "source": "API",
    "customFields": [
      {
        "id": "CUSTOM_FIELD_ID",
        "value": "Custom Value"
      }
    ]
  }'
```

### Search Contacts Example

```bash
curl -X GET "https://services.leadconnectorhq.com/contacts/?locationId=$GHL_LOCATION_ID&query=john&limit=20" \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28"
```

### Contact Object Fields

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique contact ID |
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `email` | string | Email address |
| `phone` | string | Phone number |
| `locationId` | string | Location/sub-account ID |
| `tags` | array | Tags assigned to contact |
| `source` | string | Lead source |
| `assignedTo` | string | Assigned user ID |
| `address1` | string | Street address |
| `city` | string | City |
| `state` | string | State |
| `postalCode` | string | Postal/zip code |
| `country` | string | Country |
| `companyName` | string | Company name |
| `website` | string | Website URL |
| `timezone` | string | Timezone |
| `dnd` | boolean | Do-not-disturb flag |
| `customFields` | array | Array of custom field objects |
| `dateOfBirth` | string | Date of birth |
| `dateAdded` | string | Date contact was created |
| `dateUpdated` | string | Date contact was last updated |

---

## 5. Conversations

Manage SMS, email, WhatsApp, and other communication channels.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/conversations/{conversationId}` | Get a conversation |
| `PUT` | `/conversations/{conversationId}` | Update a conversation |
| `DELETE` | `/conversations/{conversationId}` | Delete a conversation |
| `POST` | `/conversations/` | Create a new conversation |
| `GET` | `/conversations/search` | Search conversations |
| `POST` | `/conversations/messages` | Send a new message |
| `POST` | `/conversations/messages/inbound` | Create an inbound message |
| `GET` | `/conversations/{conversationId}/messages` | Get messages in a conversation |
| `PUT` | `/conversations/messages/{messageId}/status` | Update message status |
| `GET` | `/conversations/messages/{messageId}` | Get a specific message |
| `POST` | `/conversations/messages/upload` | Upload message attachments |
| `DELETE` | `/conversations/messages/email/{emailMessageId}/schedule` | Cancel scheduled email |
| `GET` | `/conversations/{conversationId}/messages/{messageId}/recordings` | Get call recordings |

### Send SMS Example

```bash
curl -X POST https://services.leadconnectorhq.com/conversations/messages \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "type": "SMS",
    "contactId": "CONTACT_ID",
    "message": "Hello! This is a test message from the API."
  }'
```

### Send Email Example

```bash
curl -X POST https://services.leadconnectorhq.com/conversations/messages \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "type": "Email",
    "contactId": "CONTACT_ID",
    "subject": "Test Email",
    "message": "<html><body><h1>Hello!</h1><p>This is a test email.</p></body></html>",
    "emailFrom": "Sender Name <sender@yourdomain.com>",
    "html": "<html><body><h1>Hello!</h1><p>This is a test email.</p></body></html>"
  }'
```

### Message Types

| Type | Description |
|---|---|
| `SMS` | Send an SMS text message |
| `Email` | Send an email |
| `WhatsApp` | Send a WhatsApp message |
| `GMB` | Google My Business message |
| `IG` | Instagram DM |
| `FB` | Facebook Messenger |
| `Live_Chat` | Website live chat |
| `Custom` | Custom channel message |

---

## 6. Calendars & Appointments

Full scheduling system: calendars, calendar groups, events, free slots, and service bookings.

### Calendar Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/calendars/` | Get all calendars in a location |
| `POST` | `/calendars/` | Create a calendar |
| `GET` | `/calendars/{calendarId}` | Get a calendar by ID |
| `PUT` | `/calendars/{calendarId}` | Update a calendar |
| `DELETE` | `/calendars/{calendarId}` | Delete a calendar |
| `GET` | `/calendars/{calendarId}/free-slots` | Get free/available slots |

### Calendar Groups

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/calendars/groups` | List calendar groups |
| `POST` | `/calendars/groups` | Create a calendar group |
| `GET` | `/calendars/groups/{groupId}` | Get calendar group |
| `PUT` | `/calendars/groups/{groupId}` | Update calendar group |
| `DELETE` | `/calendars/groups/{groupId}` | Delete calendar group |
| `DELETE` | `/calendars/groups/{groupId}/status` | Validate group slug |

### Calendar Events (Appointments)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/calendars/events` | List events |
| `POST` | `/calendars/events` | Create an event/appointment |
| `GET` | `/calendars/events/{eventId}` | Get an event |
| `PUT` | `/calendars/events/{eventId}` | Update an event |
| `DELETE` | `/calendars/events/{eventId}` | Delete an event |
| `GET` | `/calendars/events/appointments` | Get appointments by calendar |

### Calendar Resources

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/calendars/resources` | Get all resources |
| `POST` | `/calendars/resources` | Create a resource |
| `PUT` | `/calendars/resources/{resourceId}` | Update a resource |
| `DELETE` | `/calendars/resources/{resourceId}` | Delete a resource |

### Get Free Slots Example

```bash
curl -X GET "https://services.leadconnectorhq.com/calendars/{calendarId}/free-slots?startDate=2025-01-01&endDate=2025-01-31&timezone=America/New_York" \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28"
```

### Create Appointment Example

```bash
curl -X POST https://services.leadconnectorhq.com/calendars/events \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "calendarId": "CALENDAR_ID",
    "locationId": "'$GHL_LOCATION_ID'",
    "contactId": "CONTACT_ID",
    "startTime": "2025-02-01T10:00:00Z",
    "endTime": "2025-02-01T11:00:00Z",
    "title": "Consultation Call",
    "appointmentStatus": "confirmed",
    "assignedUserId": "USER_ID",
    "notes": "Initial consultation"
  }'
```

---

## 7. Opportunities (Pipelines & Deals)

Track sales pipelines, manage deals and their stages.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/opportunities/search` | Search opportunities |
| `POST` | `/opportunities/` | Create an opportunity |
| `GET` | `/opportunities/{id}` | Get an opportunity |
| `PUT` | `/opportunities/{id}` | Update an opportunity |
| `DELETE` | `/opportunities/{id}` | Delete an opportunity |
| `PUT` | `/opportunities/{id}/status` | Update opportunity status |
| `POST` | `/opportunities/{id}/followers` | Add followers |
| `DELETE` | `/opportunities/{id}/followers` | Remove followers |

### Pipelines

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/opportunities/pipelines` | List all pipelines |
| `GET` | `/opportunities/pipelines/{pipelineId}` | Get a pipeline |

### Create Opportunity Example

```bash
curl -X POST https://services.leadconnectorhq.com/opportunities/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "pipelineId": "PIPELINE_ID",
    "locationId": "'$GHL_LOCATION_ID'",
    "name": "New Deal - John Doe",
    "pipelineStageId": "STAGE_ID",
    "status": "open",
    "contactId": "CONTACT_ID",
    "monetaryValue": 5000,
    "assignedTo": "USER_ID",
    "source": "API"
  }'
```

### Opportunity Status Values

| Status | Description |
|---|---|
| `open` | Active opportunity |
| `won` | Successfully closed |
| `lost` | Lost opportunity |
| `abandoned` | Abandoned opportunity |

---

## 8. Payments

Process payments, manage orders, subscriptions, transactions, and coupons.

### Payment Integration Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/payments/integrations/provider/connect` | Connect payment provider |
| `POST` | `/payments/integrations/provider/disconnect` | Disconnect provider |
| `GET` | `/payments/integrations/provider/` | List connected providers |

### Orders

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/payments/orders` | List orders |
| `GET` | `/payments/orders/{orderId}` | Get an order |
| `POST` | `/payments/orders` | Create an order |

### Order Fulfillments

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/payments/orders/{orderId}/fulfillments` | List fulfillments |
| `POST` | `/payments/orders/{orderId}/fulfillments` | Create a fulfillment |

### Transactions

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/payments/transactions` | List transactions |
| `GET` | `/payments/transactions/{transactionId}` | Get a transaction |

### Subscriptions

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/payments/subscriptions` | List subscriptions |
| `GET` | `/payments/subscriptions/{subscriptionId}` | Get a subscription |

### Coupons

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/payments/coupons` | List coupons |
| `POST` | `/payments/coupons` | Create a coupon |
| `GET` | `/payments/coupons/{couponId}` | Get a coupon |
| `PUT` | `/payments/coupons/{couponId}` | Update a coupon |
| `DELETE` | `/payments/coupons/{couponId}` | Delete a coupon |

### Custom Payment Providers

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/payments/custom-provider/provider` | Create custom provider |
| `DELETE` | `/payments/custom-provider/provider/{providerId}` | Delete custom provider |

---

## 9. Invoices

Full invoice lifecycle management: create, send, void, collect payments.

### Invoice Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/invoices/` | List invoices |
| `POST` | `/invoices/` | Create an invoice |
| `GET` | `/invoices/{invoiceId}` | Get an invoice |
| `PUT` | `/invoices/{invoiceId}` | Update an invoice |
| `DELETE` | `/invoices/{invoiceId}` | Delete an invoice |
| `POST` | `/invoices/{invoiceId}/void` | Void an invoice |
| `POST` | `/invoices/{invoiceId}/send` | Send an invoice |
| `POST` | `/invoices/{invoiceId}/record-payment` | Record manual payment |
| `GET` | `/invoices/generate-invoice-number` | Generate invoice number |
| `GET` | `/invoices/settings` | Get invoice settings |

### Invoice Templates

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/invoices/template` | List templates |
| `POST` | `/invoices/template` | Create a template |
| `GET` | `/invoices/template/{templateId}` | Get a template |
| `PUT` | `/invoices/template/{templateId}` | Update a template |
| `DELETE` | `/invoices/template/{templateId}` | Delete a template |

### Invoice Schedules

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/invoices/schedule` | List schedules |
| `POST` | `/invoices/schedule` | Create a schedule |
| `GET` | `/invoices/schedule/{scheduleId}` | Get a schedule |
| `PUT` | `/invoices/schedule/{scheduleId}` | Update a schedule |
| `DELETE` | `/invoices/schedule/{scheduleId}` | Delete a schedule |

### Text2Pay

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/invoices/text2pay` | Create a Text2Pay link |

### Estimates

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/invoices/estimate` | List estimates |
| `POST` | `/invoices/estimate` | Create an estimate |
| `GET` | `/invoices/estimate/{estimateId}` | Get an estimate |
| `PUT` | `/invoices/estimate/{estimateId}` | Update an estimate |
| `DELETE` | `/invoices/estimate/{estimateId}` | Delete an estimate |

### Create Invoice Example

```bash
curl -X POST https://services.leadconnectorhq.com/invoices/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "altId": "'$GHL_LOCATION_ID'",
    "altType": "location",
    "name": "Invoice #001",
    "contactDetails": {
      "id": "CONTACT_ID",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "items": [
      {
        "name": "Consulting Service",
        "description": "1 hour consulting session",
        "quantity": 1,
        "price": 15000
      }
    ],
    "currency": "USD",
    "dueDate": "2025-03-01"
  }'
```

---

## 10. Workflows

Manage automations and workflow executions.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/workflows/` | List all workflows in a location |
| `GET` | `/workflows/{workflowId}` | Get a workflow |

> **Note**: Workflow creation/editing is primarily done through the GHL UI. The API allows you to list workflows and add/remove contacts from them programmatically (see Contacts section).

---

## 11. Funnels & Websites

Manage sales funnels, landing pages, and website pages.

### Funnel Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/funnels/` | List all funnels |
| `GET` | `/funnels/{funnelId}` | Get a funnel |
| `GET` | `/funnels/pages` | List funnel pages |
| `GET` | `/funnels/pages/count` | Count funnel pages |

### Funnel Redirect Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/funnels/lookup/redirect` | List funnel redirects |
| `POST` | `/funnels/lookup/redirect` | Create a funnel redirect |
| `PUT` | `/funnels/lookup/redirect/{redirectId}` | Update a funnel redirect |
| `DELETE` | `/funnels/lookup/redirect/{redirectId}` | Delete a funnel redirect |

### List Funnels Example

```bash
curl -X GET "https://services.leadconnectorhq.com/funnels/?locationId=$GHL_LOCATION_ID" \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28"
```

---

## 12. Forms

Manage forms, form submissions, and form data.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/forms/` | List all forms |
| `GET` | `/forms/submissions` | Get form submissions |
| `POST` | `/forms/upload-custom-files` | Upload files for forms |

### Get Form Submissions Example

```bash
curl -X GET "https://services.leadconnectorhq.com/forms/submissions?locationId=$GHL_LOCATION_ID&page=1&limit=20" \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28"
```

---

## 13. Surveys

Manage surveys and survey responses.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/surveys/` | List all surveys |
| `GET` | `/surveys/submissions` | Get survey submissions |

### Get Survey Submissions Example

```bash
curl -X GET "https://services.leadconnectorhq.com/surveys/submissions?locationId=$GHL_LOCATION_ID" \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28"
```

**Submission filter parameters**: `surveyId`, `contactId`, `q` (search by name/email/phone), `startAt`, `endAt`, `page`, `limit`

---

## 14. Social Planner

Manage social media posts, accounts, and OAuth connections.

### Social Media Posts

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/social-media-posting/posts` | List social posts |
| `POST` | `/social-media-posting/posts` | Create a social post |
| `GET` | `/social-media-posting/posts/{postId}` | Get a social post |
| `PUT` | `/social-media-posting/posts/{postId}` | Update a social post |
| `DELETE` | `/social-media-posting/posts/{postId}` | Delete a social post |
| `PATCH` | `/social-media-posting/posts/{postId}` | Patch a social post |

### Social Media Accounts

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/social-media-posting/{locationId}/accounts` | List connected accounts |
| `DELETE` | `/social-media-posting/{locationId}/accounts/{accountId}` | Disconnect account |

### Social Media OAuth

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/social-media-posting/oauth/facebook/start` | Start Facebook OAuth |
| `POST` | `/social-media-posting/oauth/google/start` | Start Google OAuth |
| `POST` | `/social-media-posting/oauth/instagram/start` | Start Instagram OAuth |
| `POST` | `/social-media-posting/oauth/linkedin/start` | Start LinkedIn OAuth |
| `POST` | `/social-media-posting/oauth/tiktok/start` | Start TikTok OAuth |
| `POST` | `/social-media-posting/oauth/twitter/start` | Start Twitter/X OAuth |

### Supported Social Platforms

| Platform | Post Types |
|---|---|
| Facebook | Text, Image, Video, Link, Reel, Story |
| Instagram | Image, Carousel, Reel, Story |
| Google Business | Text, Image, Event, Offer |
| LinkedIn | Text, Image, Video |
| TikTok | Video |
| Twitter/X | Text, Image, Video |

### Create Social Post Example

```bash
curl -X POST https://services.leadconnectorhq.com/social-media-posting/posts \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "locationId": "'$GHL_LOCATION_ID'",
    "accountIds": ["ACCOUNT_ID"],
    "type": "post",
    "summary": "Check out our latest offers!",
    "media": [
      {
        "type": "image",
        "url": "https://example.com/image.jpg"
      }
    ],
    "scheduledAt": "2025-03-01T10:00:00Z",
    "status": "scheduled"
  }'
```

---

## 15. Courses & Memberships

Manage online courses, enrollments, lessons, and certificates.

### Course Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/courses/` | List all courses |
| `POST` | `/courses/` | Create a course |
| `GET` | `/courses/{courseId}` | Get a course |
| `PUT` | `/courses/{courseId}` | Update a course |
| `DELETE` | `/courses/{courseId}` | Delete a course |

### Course Enrollment

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/courses/{courseId}/enrollments` | Enroll a contact |
| `GET` | `/courses/{courseId}/enrollments` | List enrollments |
| `DELETE` | `/courses/{courseId}/enrollments/{enrollmentId}` | Remove enrollment |

### Course Lessons

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/courses/{courseId}/lessons` | List lessons |
| `POST` | `/courses/{courseId}/lessons/{lessonId}/complete` | Mark lesson complete |

### Course Certificates

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/courses/{courseId}/certificates` | List certificates |

### Course Webhooks

| Event | Description |
|---|---|
| `CourseCreated` | When a new course is created |
| `CourseUpdated` | When a course is updated |
| `LessonCompleted` | When a student completes a lesson |
| `CourseCompleted` | When a student completes all lessons |
| `CourseEnrolled` | When a student is enrolled |

---

## 16. Media Storage

Upload, manage, and organize files and folders.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/medias/` | List files and folders |
| `POST` | `/medias/upload-file` | Upload a file |
| `DELETE` | `/medias/{fileId}` | Delete a file |
| `PUT` | `/medias/{fileId}` | Update file metadata |
| `GET` | `/medias/{fileId}` | Get file details |
| `POST` | `/medias/folder` | Create a folder |
| `DELETE` | `/medias/folder/{folderId}` | Delete a folder |

### Upload File Example

```bash
curl -X POST https://services.leadconnectorhq.com/medias/upload-file \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28" \
  -F "file=@/path/to/file.png" \
  -F "locationId=$GHL_LOCATION_ID" \
  -F "name=my-image.png"
```

### File Size Limits

| Type | Max Size |
|---|---|
| General files (images, PDFs, etc.) | 25 MB |
| Video files | 500 MB |

---

## 17. Companies

Manage company records and their associations.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/companies/` | List companies |
| `POST` | `/companies/` | Create a company |
| `GET` | `/companies/{companyId}` | Get a company |
| `PUT` | `/companies/{companyId}` | Update a company |
| `DELETE` | `/companies/{companyId}` | Delete a company |

### Create Company Example

```bash
curl -X POST https://services.leadconnectorhq.com/companies/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "name": "Acme Corp",
    "locationId": "'$GHL_LOCATION_ID'",
    "phone": "+1234567890",
    "email": "info@acme.com",
    "website": "https://acme.com",
    "address": "123 Main St",
    "city": "New York",
    "state": "NY",
    "postalCode": "10001",
    "country": "US"
  }'
```

---

## 18. Custom Fields

Create and manage custom data fields across contacts, opportunities, companies, and more.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/custom-fields/` | List custom fields |
| `POST` | `/custom-fields/` | Create a custom field |
| `GET` | `/custom-fields/{fieldId}` | Get a custom field |
| `PUT` | `/custom-fields/{fieldId}` | Update a custom field |
| `DELETE` | `/custom-fields/{fieldId}` | Delete a custom field |

### Custom Field Data Types

| Type | Description |
|---|---|
| `TEXT` | Single-line text |
| `LARGE_TEXT` | Multi-line text |
| `NUMERICAL` | Number field |
| `PHONE` | Phone number |
| `MONETORY` | Currency value |
| `CHECKBOX` | Boolean checkbox |
| `SINGLE_OPTIONS` | Dropdown (single select) |
| `MULTIPLE_OPTIONS` | Multi-select |
| `FLOAT` | Decimal number |
| `TIME` | Time field |
| `DATE` | Date field |
| `TEXTBOX_LIST` | List of text items |
| `FILE_UPLOAD` | File attachment |
| `SIGNATURE` | Signature field |

### Create Custom Field Example

```bash
curl -X POST https://services.leadconnectorhq.com/custom-fields/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "name": "Preferred Contact Method",
    "dataType": "SINGLE_OPTIONS",
    "locationId": "'$GHL_LOCATION_ID'",
    "model": "contact",
    "options": [
      {"value": "email", "name": "Email"},
      {"value": "phone", "name": "Phone"},
      {"value": "sms", "name": "SMS"}
    ]
  }'
```

---

## 19. Custom Values

Dynamic placeholders that can be used across the platform (emails, SMS, funnels, etc.).

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/custom-values/` | List custom values |
| `POST` | `/custom-values/` | Create a custom value |
| `GET` | `/custom-values/{customValueId}` | Get a custom value |
| `PUT` | `/custom-values/{customValueId}` | Update a custom value |
| `DELETE` | `/custom-values/{customValueId}` | Delete a custom value |

### Create Custom Value Example

```bash
curl -X POST https://services.leadconnectorhq.com/custom-values/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "name": "Business Hours",
    "value": "Mon-Fri 9AM-5PM EST",
    "locationId": "'$GHL_LOCATION_ID'"
  }'
```

---

## 20. Businesses

Manage business entities within a location.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/businesses/` | List businesses by location |
| `POST` | `/businesses/` | Create a business |
| `GET` | `/businesses/{businessId}` | Get a business |
| `PUT` | `/businesses/{businessId}` | Update a business |
| `DELETE` | `/businesses/{businessId}` | Delete a business |

---

## 21. Users

Manage users and team members within the platform.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/users/` | List users |
| `GET` | `/users/{userId}` | Get a user |
| `PUT` | `/users/{userId}` | Update a user |
| `DELETE` | `/users/{userId}` | Delete a user |
| `POST` | `/users/` | Create a user |
| `GET` | `/users/search` | Search users |

---

## 22. Locations (Sub-Accounts)

Manage sub-accounts within an agency account.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/locations/` | List locations |
| `POST` | `/locations/` | Create a location |
| `GET` | `/locations/{locationId}` | Get a location |
| `PUT` | `/locations/{locationId}` | Update a location |
| `DELETE` | `/locations/{locationId}` | Delete a location |
| `GET` | `/locations/search` | Search locations |
| `GET` | `/locations/{locationId}/tags` | Get location tags |
| `POST` | `/locations/{locationId}/tags` | Create a tag |
| `PUT` | `/locations/{locationId}/tags/{tagId}` | Update a tag |
| `DELETE` | `/locations/{locationId}/tags/{tagId}` | Delete a tag |
| `GET` | `/locations/{locationId}/customFields` | Get location custom fields |
| `GET` | `/locations/{locationId}/customValues` | Get location custom values |
| `GET` | `/locations/{locationId}/tasks/search` | Search tasks in a location |

---

## 23. Associations

Manage relationships between entities (contacts, companies, opportunities, custom objects).

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/associations/` | List all associations |
| `POST` | `/associations/` | Create an association |
| `GET` | `/associations/{associationId}` | Get an association |
| `DELETE` | `/associations/{associationId}` | Delete an association |

---

## 24. Snapshots

Manage account configuration templates (snapshots).

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/snapshots/` | List all snapshots |
| `POST` | `/snapshots/share/link` | Create a share link for a snapshot |
| `GET` | `/snapshots/{snapshotId}/push` | Get snapshot push status |

### List Snapshots Example

```bash
curl -X GET "https://services.leadconnectorhq.com/snapshots/?companyId=YOUR_COMPANY_ID" \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Version: 2021-07-28"
```

---

## 25. SaaS API

For agencies reselling GHL as white-label SaaS.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/saas-api/public-api/locations` | List SaaS locations |
| `PUT` | `/saas-api/public-api/locations/{locationId}` | Update SaaS location |
| `POST` | `/saas-api/public-api/locations` | Create SaaS location |
| `PUT` | `/saas-api/public-api/bulk-disable-saas/{locationId}` | Bulk disable SaaS |
| `POST` | `/saas-api/public-api/enable-saas/{locationId}` | Enable SaaS for location |
| `GET` | `/saas-api/public-api/rebilling/{companyId}` | Get rebilling info |
| `PUT` | `/saas-api/public-api/update-rebilling/{companyId}` | Update rebilling |

---

## 26. Webhooks

Configure real-time event notifications.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/webhooks/` | List webhooks |
| `POST` | `/webhooks/` | Create a webhook |
| `GET` | `/webhooks/{webhookId}` | Get a webhook |
| `PUT` | `/webhooks/{webhookId}` | Update a webhook |
| `DELETE` | `/webhooks/{webhookId}` | Delete a webhook |

### Available Webhook Events

| Category | Events |
|---|---|
| **Contact** | `ContactCreate`, `ContactUpdate`, `ContactDelete`, `ContactDndUpdate`, `ContactTagUpdate` |
| **Conversation** | `ConversationUnreadUpdate`, `ConversationProviderUpdate` |
| **Appointment** | `AppointmentCreate`, `AppointmentUpdate`, `AppointmentDelete` |
| **Opportunity** | `OpportunityCreate`, `OpportunityUpdate`, `OpportunityDelete`, `OpportunityStageUpdate`, `OpportunityStatusUpdate`, `OpportunityMonetaryValueUpdate`, `OpportunityAssignedToUpdate` |
| **Invoice** | `InvoiceCreate`, `InvoiceUpdate`, `InvoiceDelete`, `InvoiceVoid`, `InvoiceSent`, `InvoicePartiallyPaid`, `InvoicePaid` |
| **Payment** | `PaymentReceived`, `PaymentRefunded` |
| **Order** | `OrderCreate`, `OrderStatusUpdate`, `OrderFulfillmentUpdate` |
| **Course** | `CourseCreated`, `CourseUpdated`, `LessonCompleted`, `CourseCompleted`, `CourseEnrolled` |
| **Membership** | `MembershipNew`, `MembershipAccessGranted`, `MembershipAccessRemoved`, `MembershipProductCompletion` |
| **Form** | `FormSubmission` |
| **Survey** | `SurveySubmission` |
| **Note** | `NoteCreate`, `NoteUpdate`, `NoteDelete` |
| **Task** | `TaskCreate`, `TaskComplete`, `TaskDelete` |
| **Inbound Message** | `InboundMessage` |
| **Outbound Message** | `OutboundMessage` |
| **Call** | `InboundCallCompleted`, `OutboundCallCompleted` |
| **SaaS** | `SaasPlanCreate`, `SaasPlanUpdate` |
| **Document** | `DocumentSent`, `DocumentViewed`, `DocumentSigned`, `DocumentAccepted`, `DocumentCompleted` |

### Create Webhook Example

```bash
curl -X POST https://services.leadconnectorhq.com/webhooks/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "locationId": "'$GHL_LOCATION_ID'",
    "url": "https://your-server.com/webhook",
    "events": ["ContactCreate", "ContactUpdate", "AppointmentCreate"],
    "secret": "your-webhook-secret"
  }'
```

---

## 27. Triggers

Workflow triggers for automating actions based on events.

### Built-in Trigger Categories

| Category | Triggers |
|---|---|
| **Contact** | Contact Created, Contact Updated, Contact Tag Added, Contact Tag Removed, Contact DND |
| **Appointment** | Customer Booked Appointment, Appointment Status Changed |
| **Pipeline/Opportunity** | Pipeline Stage Changed, Opportunity Status Changed, Opportunity Created |
| **Form/Survey** | Form Submitted, Survey Submitted |
| **Payment** | Payment Received, Invoice Paid, Subscription Created |
| **Membership** | New Signup, Access Granted, Access Removed, Product Completion |
| **Communication** | Inbound Call, Missed Call, Voicemail, SMS Received, Email Received |
| **Document** | Document Sent, Viewed, Signed, Accepted, Completed |
| **Scheduler** | Timed trigger (hourly, daily, weekly, monthly, custom cron) |

### Marketplace Workflow Triggers

Developers can create **custom triggers** that push data from external apps into GHL workflows:

```bash
curl -X POST https://services.leadconnectorhq.com/workflows/triggers \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "locationId": "'$GHL_LOCATION_ID'",
    "triggerId": "CUSTOM_TRIGGER_ID",
    "contactId": "CONTACT_ID",
    "data": {
      "key1": "value1",
      "key2": "value2"
    }
  }'
```

---

## 28. Blogs

Manage blog posts, authors, and categories.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/blogs/` | List blog posts |
| `POST` | `/blogs/` | Create a blog post |
| `GET` | `/blogs/{postId}` | Get a blog post |
| `PUT` | `/blogs/{postId}` | Update a blog post |
| `DELETE` | `/blogs/{postId}` | Delete a blog post |
| `GET` | `/blogs/authors` | List blog authors |
| `GET` | `/blogs/categories` | List blog categories |
| `POST` | `/blogs/categories` | Create a category |
| `PUT` | `/blogs/{postId}/check-slug` | Check slug availability |

---

## 29. Documents & Contracts

Manage documents, contracts, and e-signatures.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/documents/` | List documents |
| `GET` | `/documents/{documentId}` | Get a document |

### Document Webhook Events

| Event | Description |
|---|---|
| `DocumentSent` | Document sent to recipient |
| `DocumentViewed` | Document viewed |
| `DocumentSigned` | Document signed |
| `DocumentAccepted` | Document accepted |
| `DocumentCompleted` | Document fully completed |

---

## 30. Reputation Management & Reviews

Manage review requests, monitor reviews, and respond to feedback.

### Capabilities

- **Automated review requests** via SMS and email after customer interactions
- **Review monitoring** across Google and Facebook
- **Centralized response management** from one dashboard
- **Sentiment analysis** for incoming reviews
- **Workflow triggers** based on review events

> **Note**: Reputation management is primarily managed within GHL workflows. Use Contact and Conversation APIs to automate review request sending. Use webhooks to listen for review-related events.

### Automated Review Request Workflow

1. Use the Contacts API to identify customers who completed a service
2. Send an SMS/email using the Conversations API with a review link
3. Set up webhooks to monitor review responses
4. Use workflows to handle positive vs. negative review routing

---

## 31. Email / SMS / Calls

### Sending Communications

All communication is handled through the **Conversations API** (Section 5):

| Channel | Type Value | Notes |
|---|---|---|
| SMS | `SMS` | Requires registered phone number |
| Email | `Email` | Requires verified sending domain |
| WhatsApp | `WhatsApp` | Requires WhatsApp Business API setup |
| Phone Calls | Via workflows | Outbound calling via workflow triggers |
| Voicemail Drops | Via workflows | Pre-recorded voicemail drops |

### Voicemail & Call Recordings

- Access call recordings via `/conversations/{conversationId}/messages/{messageId}/recordings`
- Inbound call webhook payloads include `recordingUrl` when available
- Configure voicemail drops in workflow actions

---

## 32. Links

Manage tracking links and URLs.

### Link (Trigger Link) Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/links/` | List links |
| `POST` | `/links/` | Create a link |
| `PUT` | `/links/{linkId}` | Update a link |
| `DELETE` | `/links/{linkId}` | Delete a link |

---

## 33. Tags

Manage tags for contacts and other entities.

### Endpoints (via Locations API)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/locations/{locationId}/tags` | List all tags |
| `POST` | `/locations/{locationId}/tags` | Create a new tag |
| `GET` | `/locations/{locationId}/tags/{tagId}` | Get a tag |
| `PUT` | `/locations/{locationId}/tags/{tagId}` | Update a tag |
| `DELETE` | `/locations/{locationId}/tags/{tagId}` | Delete a tag |

### Apply/Remove Tags on Contacts

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/contacts/{contactId}/tags` | Add tags to contact |
| `DELETE` | `/contacts/{contactId}/tags` | Remove tags from contact |

---

## 34. Notes & Tasks

Manage notes and tasks attached to contacts.

### Notes Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/contacts/{contactId}/notes` | Get contact notes |
| `POST` | `/contacts/{contactId}/notes` | Create a note |
| `GET` | `/contacts/{contactId}/notes/{noteId}` | Get a specific note |
| `PUT` | `/contacts/{contactId}/notes/{noteId}` | Update a note |
| `DELETE` | `/contacts/{contactId}/notes/{noteId}` | Delete a note |

### Tasks Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/contacts/{contactId}/tasks` | Get contact tasks |
| `POST` | `/contacts/{contactId}/tasks` | Create a task |
| `GET` | `/contacts/{contactId}/tasks/{taskId}` | Get a specific task |
| `PUT` | `/contacts/{contactId}/tasks/{taskId}` | Update a task |
| `DELETE` | `/contacts/{contactId}/tasks/{taskId}` | Delete a task |
| `PUT` | `/contacts/{contactId}/tasks/{taskId}/completed` | Mark task complete |

---

## 35. Products & Prices

Manage products and their pricing.

### Products Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/products/` | List products |
| `POST` | `/products/` | Create a product |
| `GET` | `/products/{productId}` | Get a product |
| `PUT` | `/products/{productId}` | Update a product |
| `DELETE` | `/products/{productId}` | Delete a product |

### Prices Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/products/{productId}/prices` | List prices |
| `POST` | `/products/{productId}/prices` | Create a price |
| `GET` | `/products/{productId}/prices/{priceId}` | Get a price |
| `PUT` | `/products/{productId}/prices/{priceId}` | Update a price |
| `DELETE` | `/products/{productId}/prices/{priceId}` | Delete a price |

### Create Product Example

```bash
curl -X POST https://services.leadconnectorhq.com/products/ \
  -H "Authorization: Bearer $GHL_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Version: 2021-07-28" \
  -d '{
    "locationId": "'$GHL_LOCATION_ID'",
    "name": "Premium Consulting Package",
    "description": "Monthly consulting package",
    "productType": "DIGITAL",
    "availableInStore": true
  }'
```

---

## 36. Object Records (Custom Objects)

Manage custom object records for extending the CRM data model.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/objects/records` | List object records |
| `POST` | `/objects/records` | Create an object record |
| `GET` | `/objects/records/{recordId}` | Get a record |
| `PUT` | `/objects/records/{recordId}` | Update a record |
| `DELETE` | `/objects/records/{recordId}` | Delete a record |

---

## 37. OAuth & Marketplace Apps

### Building a Marketplace App

1. **Register** at [marketplace.gohighlevel.com](https://marketplace.gohighlevel.com)
2. **Create an app** with required scopes
3. **Set redirect URI** for OAuth callbacks
4. **Implement OAuth flow** (see Section 1)
5. **Submit for review** (for public apps)
6. **Distribute** via GHL Marketplace

### App Distribution Types

| Type | Description |
|---|---|
| **Public** | Available to all GHL users in the marketplace |
| **Private** | Available only to your agency and sub-accounts |
| **Custom** | Built for specific client integrations |

### Private Integration Token

For single-account use without full OAuth flow:

1. Go to **Settings** → **Integrations** → **Private Integrations** in GHL
2. Create a new integration
3. Select required scopes
4. Copy the generated token
5. Use as Bearer token in API calls

---

## 38. Self-Update Instructions

> **IMPORTANT**: This skill should be kept up-to-date with the latest GHL API changes.

### When to Update This Skill

1. **API call fails** with a 404 or unexpected error → search for the correct endpoint
2. **New feature needed** not listed here → research the GHL documentation
3. **Endpoint changed** or deprecated → update the affected section
4. **New webhook event** available → add to the webhooks section
5. **Rate limits changed** → update Section 3

### How to Update

1. **Search the official docs**: Visit [marketplace.gohighlevel.com/docs/](https://marketplace.gohighlevel.com/docs/)
2. **Search GitHub docs**: Check [github.com/GoHighLevel/highlevel-api-docs](https://github.com/GoHighLevel/highlevel-api-docs)
3. **Search the web**: Look for "Go High Level API v2 [feature name] endpoint"
4. **Verify the endpoint** by making a test API call
5. **Update this SKILL.md** with the correct information
6. **Add examples** for any new endpoints

### Official Resources

| Resource | URL |
|---|---|
| API Documentation | [marketplace.gohighlevel.com/docs/](https://marketplace.gohighlevel.com/docs/) |
| GitHub API Docs | [github.com/GoHighLevel/highlevel-api-docs](https://github.com/GoHighLevel/highlevel-api-docs) |
| Developer Portal | [marketplace.gohighlevel.com](https://marketplace.gohighlevel.com) |
| Changelog | [ideas.gohighlevel.com](https://ideas.gohighlevel.com) |
| Community | [community.gohighlevel.com](https://community.gohighlevel.com) |

### Changelog

| Date | Change |
|---|---|
| 2026-02-21 | Initial skill creation with 37 feature categories |

---

## Quick Reference: All API Base Paths

| Module | Base Path |
|---|---|
| Contacts | `/contacts/` |
| Conversations | `/conversations/` |
| Calendars | `/calendars/` |
| Opportunities | `/opportunities/` |
| Payments | `/payments/` |
| Invoices | `/invoices/` |
| Workflows | `/workflows/` |
| Funnels | `/funnels/` |
| Forms | `/forms/` |
| Surveys | `/surveys/` |
| Social Planner | `/social-media-posting/` |
| Courses | `/courses/` |
| Media | `/medias/` |
| Companies | `/companies/` |
| Custom Fields | `/custom-fields/` |
| Custom Values | `/custom-values/` |
| Businesses | `/businesses/` |
| Users | `/users/` |
| Locations | `/locations/` |
| Associations | `/associations/` |
| Snapshots | `/snapshots/` |
| SaaS API | `/saas-api/public-api/` |
| Webhooks | `/webhooks/` |
| Blogs | `/blogs/` |
| Documents | `/documents/` |
| Links | `/links/` |
| Tags | `/locations/{locationId}/tags` |
| Notes | `/contacts/{contactId}/notes` |
| Tasks | `/contacts/{contactId}/tasks` |
| Products | `/products/` |
| Prices | `/products/{productId}/prices` |
| Object Records | `/objects/records` |
| OAuth | `/oauth/` |
