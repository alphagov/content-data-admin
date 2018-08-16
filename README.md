# Content Data Admin

A front end for the [data warehouse](https://github.com/alphagov/content-performance-manager).

This application is currently in development for a private beta.

## Ruby version

2.5.1

## Dependencies

* The [data warehouse](https://github.com/alphagov/content-performance-manager)

## Setting up the application

### Using the GDS development VM

See the [getting started guide](https://docs.publishing.service.gov.uk/getting-started.html) for instructions about setting up and running your development VM.

In the development VM, go to:

```bash
cd /var/govuk/govuk-puppet/development-vm
```

Then run:

 ```bash
 bowl content-data-admin
 ```

The application can be accessed from:

http://content-data-admin.dev.gov.uk

## Running the test suite
To run the test suite:
 ```bash
 $ bundle exec rake
 ```

## Licence

[MIT License](LICENCE)

