# Content Data Admin

A front end for the [Content Data API].

This application is currently in development for a private beta.

## Ruby version

2.5.1

## Dependencies

* The [Content Data API]

[Content Data API]: https://github.com/alphagov/content-data-api

## Running the application

### Standalone

Launch the rails server:

```bash
bundle exec unicorn -c config/unicorn.rb
```

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

