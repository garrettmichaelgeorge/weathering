# README

[![Ruby Code Style](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)

## Getting started

A [Devbox](https://www.jetify.com/docs/devbox/) configuration is provided for
convenient onboarding. Devbox handles system dependencies for this project,
including Ruby and Node.js versions as well as PostgreSQL and bundler.

If not using Devbox, the system dependencies found in
[devbox.json](./devbox.json) can be installed using the package manager of your
choice.

To get started using Devbox:
1. [Install](https://www.jetify.com/docs/devbox/installing_devbox/) Devbox.
1. Enter the Devbox shell: `devbox shell`. All system dependencies should now be installed.
1. (If using the Devbox-supplied PostgreSQL) Initialize the PostgreSQL database: `initdb`
1. Create the Rails Dev database: `bin/rails db:create`
1. `bundle install`
1. Start app services: `devbox services up`

You are now ready to modify source code, etc.

Other helpful commands:
1. Run unit tests: `bin/rails test`
1. Run system tests: `bin/rails test:system`

## Limitations and assumptions

From the requirements, "zip codes" is interpreted as "postal codes."

Weathering does not always infer the postal code from the address input. This is
due to a
[limitation](https://nominatim.org/release-docs/latest/customize/Postcodes/) in
the Nominatim/OpenStreetMap geocoding backend. If it doesn't receive a postal
code from the geocoding service, then it avoids the forecast cache altogether.

For cache store, Weathering uses the Rails 8 default option of Solid Cache,
which uses a relational database (in this case, PostgreSQL). In the future,
other cache stores could be considered such as Redis or Memcached.
