"""
Example: Using the Official GHL Python SDK
============================================
Prerequisites:
    pip install gohighlevel-api-client
    
    Set environment variables:
      export GHL_CLIENT_ID="your-client-id"
      export GHL_CLIENT_SECRET="your-client-secret"
      export GHL_LOCATION_ID="your-location-id"
"""

import asyncio
import os
from highlevel import HighLevel


# --- Configuration ---
CLIENT_ID = os.getenv("GHL_CLIENT_ID", "your_client_id")
CLIENT_SECRET = os.getenv("GHL_CLIENT_SECRET", "your_client_secret")
LOCATION_ID = os.getenv("GHL_LOCATION_ID", "your_location_id")


async def demo_contacts(client: HighLevel):
    """Demonstrate Contact operations via the SDK."""
    print("\n=== Contact Operations ===\n")

    # Search contacts
    print("--- Searching contacts ---")
    contacts = await client.contacts.search_contacts_advanced({
        "locationId": LOCATION_ID,
        "pageLimit": 5,
    })
    print(f"Found contacts: {contacts}")

    # Create a contact
    print("\n--- Creating a contact ---")
    new_contact = await client.contacts.create_contact({
        "firstName": "Jane",
        "lastName": "SDK-Test",
        "email": "jane.sdk@example.com",
        "phone": "+15551234567",
        "locationId": LOCATION_ID,
        "tags": ["sdk-test", "python"],
        "source": "Python SDK Example",
    })
    print(f"Created contact: {new_contact}")

    return new_contact


async def demo_calendars(client: HighLevel):
    """Demonstrate Calendar operations via the SDK."""
    print("\n=== Calendar Operations ===\n")

    # List calendars
    print("--- Listing calendars ---")
    calendars = await client.calendars.get_calendars({
        "locationId": LOCATION_ID,
    })
    print(f"Calendars: {calendars}")

    return calendars


async def demo_opportunities(client: HighLevel):
    """Demonstrate Opportunity operations via the SDK."""
    print("\n=== Opportunity Operations ===\n")

    # Get pipelines
    print("--- Listing pipelines ---")
    pipelines = await client.opportunities.get_pipelines({
        "locationId": LOCATION_ID,
    })
    print(f"Pipelines: {pipelines}")

    return pipelines


async def demo_conversations(client: HighLevel):
    """Demonstrate Conversation operations via the SDK."""
    print("\n=== Conversation Operations ===\n")

    # Search conversations
    print("--- Searching conversations ---")
    conversations = await client.conversations.search_conversations({
        "locationId": LOCATION_ID,
    })
    print(f"Conversations: {conversations}")

    return conversations


async def demo_workflows(client: HighLevel):
    """Demonstrate Workflow operations via the SDK."""
    print("\n=== Workflow Operations ===\n")

    # List workflows
    print("--- Listing workflows ---")
    workflows = await client.workflows.get_workflows({
        "locationId": LOCATION_ID,
    })
    print(f"Workflows: {workflows}")

    return workflows


async def demo_forms_surveys(client: HighLevel):
    """Demonstrate Forms and Surveys operations."""
    print("\n=== Forms & Surveys ===\n")

    # List forms
    print("--- Listing forms ---")
    forms = await client.forms.get_forms({
        "locationId": LOCATION_ID,
    })
    print(f"Forms: {forms}")

    # List surveys
    print("\n--- Listing surveys ---")
    surveys = await client.surveys.get_surveys({
        "locationId": LOCATION_ID,
    })
    print(f"Surveys: {surveys}")


async def demo_products(client: HighLevel):
    """Demonstrate Product operations."""
    print("\n=== Product Operations ===\n")

    # List products
    print("--- Listing products ---")
    products = await client.products.list_products({
        "locationId": LOCATION_ID,
    })
    print(f"Products: {products}")


async def main():
    """Run all SDK demos."""
    print("=" * 60)
    print("GHL Python SDK Demo")
    print("=" * 60)

    # Initialize client
    client = HighLevel(
        client_id=CLIENT_ID,
        client_secret=CLIENT_SECRET,
    )

    try:
        await demo_contacts(client)
        await demo_calendars(client)
        await demo_opportunities(client)
        await demo_conversations(client)
        await demo_workflows(client)
        await demo_forms_surveys(client)
        await demo_products(client)
    except Exception as e:
        print(f"\nError: {e}")
        print("Make sure your GHL_CLIENT_ID, GHL_CLIENT_SECRET, and GHL_LOCATION_ID are set correctly.")

    print("\n" + "=" * 60)
    print("Demo complete!")
    print("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())
