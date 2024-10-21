# redmine_3cx

This Redmine CRM 3CX integration plugin offers a configuration template along with a Basic Auth-protected HTTP endpoint for seamless integration with the Redmine Conctacts CRM system.

## Accessing Contacts API

To access the contacts API in the Redmine CRM plugin, the current user must have the `:use_api` permission. This permission can be found under the Project permissions. It is important to note that the user account must have the `use_api` permission for the project that the contacts are part of, otherwise the project contacts will be skipped.

## Production Environment

### Preconditions

* Make sure that [Redmine](https://github.com/redmine/redmine) is installed.
* Make sure that [Redmine Contacts](https://www.redmineup.com/pages/plugins/crm) is installed.
* Make sure that you have admin privileges on the Redmine Server.

### Setup


1. Enter the following commands in your terminal:

```bash
cd /path/to/redmine
git clone https://github.com/renuo/redmine_3cx plugins/redmine_3cx
cd plugins/redmine_3cx
bin/production_setup
bundle exec rails s -e production
```

2. Login with your admin account.
3. Make sure that API authentication is enabled (Settings / API).

Accessing API Key
* (Not very safe) Use the API Key of the administrator account (Navbar: My account/API access key/Show).
* (Safer) Use the API Key of the service account (login: 3cx_service_account, password: password) and assign it to the relevant projects.

HTTPs

* The default CRM template enforces HTTPs connection because the API key is leaked otherwise but you can change the template manually if you want to live dangerously.

3CX Integration

1. `3CX Cloud Sidebar: Advanced/Contacts/Options/Match Caller ID`: select "Match exactly"
1. `3CX Cloud Sidebar: Setings/Options/General Options`: uncheck "Hide CRM Contacts from 3CX Apps Company phonebook"
1. `3CX Cloud Sidebar: Settings/CRM`: 
    * Upload CRM configuration
    * Fill in API Key (e.g. 2f5a9d4b1c7e8f3a6d2b0c9a1f8a3e1b4c7e5d9a)
    * Fill in Domain (e.g. redmine.example.com).
1. Click `Test` and enter a phone number in your CRM.
1. Click `OK` to add the integration.
1. Restart all 3CX Services from Dashboard / Services
1. Enjoy the integration!

## Development Environment

```bash
git clone -b 5.1-stable https://github.com/redmine/redmine
```

Install the Redmine Contacts Plugin via https://www.redmine.org/plugins/redmine_contacts

```bash
git clone https://github.com/renuo/redmine_3cx redmine/plugins/redmine_3cx
cd redmine/plugins/redmine_3cx
bin/setup
bin/run
```
## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
