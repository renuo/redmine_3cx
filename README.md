# Redmine Contacts CRM 3CX Integration Guide

This Redmine plugin integrates the Redmine Contacts CRM system with 3CX, providing a configuration template and Basic Auth-protected HTTP endpoints for seamless contact lookup and search functionality.

## Supported Scenarios

### Scenario 1: Incoming Call Contact Lookup
**Endpoint:** `https://[RedmineDomain]/3cx/lookup.json?phone=[Number]`

When an incoming call is received in 3CX, the system queries the CRM API using the caller's phone number. If a matching contact exists in the Redmine Contacts database, that contact is automatically displayed in the 3CX phonebook.

### Scenario 2: Contact Search
**Endpoint:** `https://[RedmineDomain]/3cx/search.json?query=[Query]`

When a user searches for a contact within 3CX, the CRM API is queried using free text search. The search matches against first name, last name, company name, phone numbers, and email addresses, returning all matching contacts from the Redmine Contacts database.

## Accessing Contacts API

To access the contacts API through the Redmine CRM plugin, the current user must have the `:use_api` permission, which can be configured under Project permissions. The user account must have this permission for the specific project containing the contacts; otherwise, those contacts will be skipped in results.

**Contact Priority:** When multiple contacts share the same phone number, individual contacts are prioritized over company contacts in the results.

## Production Environment Setup

### Preconditions
* Redmine is installed
* Redmine Contacts plugin is installed
* You have admin privileges on the Redmine server

### Installation Steps

1. Clone the plugin into your Redmine installation:
```bash
cd /path/to/redmine
git clone https://github.com/renuo/redmine_3cx plugins/redmine_3cx
cd plugins/redmine_3cx
bin/production_setup
bundle exec rails s -e production
```

2. Enable the plugin and API. Choose one of the following approaches:

   **Option A: Automated Setup (Recommended)**
   ```bash
   rails redmine_3cx:enable_plugin
   ```
   This command will:
   * Enable the 3CX plugin
   * Enable the Redmine REST API
   * Verify both settings are correctly configured

   **Option B: Manual Setup**
   * Log in to Redmine with your admin account
   * Enable API authentication in Redmine settings (Settings > API)
   * Enable the 3CX plugin through the Plugins interface (Administration > Plugins)

3. Verify the setup was successful by checking that both the plugin and REST API are enabled in Redmine settings.

### Service Account Setup

Run the setup task to create a dedicated service account for API access:

```bash
rake redmine_3cx:setup_service_account
```

This command will:
* Create a role `3cx_api` with the `:use_api` permission
* Create a user `3cx_service_account` with API access
* Add the service account to all projects with the contacts module enabled
* Output the API key to use in 3CX configuration

**Alternative:** Use the administrator account's API key (Navbar > My account > API access key > Show), though a dedicated service account is recommended.

**HTTPS Requirement:** The default CRM template enforces HTTPS to prevent API key exposure. Manual configuration is required if you want to use HTTP.

### 3CX Configuration

1. In 3CX Cloud Sidebar, navigate to Advanced > Contacts > Options > Match Caller ID and select "Match exactly"
2. In 3CX Cloud Sidebar, go to Settings > Options > General Options and uncheck "Hide CRM Contacts from 3CX Apps Company phonebook"
3. In 3CX Cloud Sidebar, go to Settings > CRM:
   * Upload the CRM configuration template
   * Enter your API Key (example: `2f5a9d4b1c7e8f3a6d2b0c9a1f8a3e1b4c7e5d9a`)
   * Enter your Domain (example: `redmine.example.com`)
4. Click Test and enter a phone number that exists in your CRM to verify the connection
5. Click OK to complete the integration setup
6. Restart all 3CX Services from the Dashboard > Services
7. The integration is now active

## Development Environment

### Setup

```bash
git clone -b 5.1-stable https://github.com/redmine/redmine
```

Install the Redmine Contacts plugin using the plugin repository at https://www.redmine.org/plugins/redmine_contacts

```bash
git clone https://github.com/renuo/redmine_3cx redmine/plugins/redmine_3cx
cd redmine/plugins/redmine_3cx
bin/setup
bin/run
```

### Manual Testing of APIs

Test the phone lookup scenario:
```bash
rake redmine_3cx:phone_lookup phone="+41 79 123 45 67"
rake redmine_3cx:phone_lookup phone="+41 79 123 45 67" login="admin"
```

Test the search scenario:
```bash
rake redmine_3cx:contact_search query="John"
rake redmine_3cx:contact_search query="John" login="admin" host="myapp.example.com"
```

## Copyright

Published by Renuo under MIT License
