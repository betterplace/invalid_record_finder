# InvalidRecordFinder

Find entries in your database that no longer pass your validations.

These poor little records need your help because they can't be updated anymore 😢

## Installation

Bundle or gem install `invalid_record_finder`.

## Usage

### Basic example

A common use case is to periodically check all records and send mails if invalid records are found.

Models must inherit from `ApplicationRecord` and `ActionMailer` must be configured for the mail sending to work.

```
# my_regular_task.rake

result = InvalidRecordFinder.call
result.mail(from: 'noreply@myapp.com', to: 'devs@myapp.com')
```

### Targetting specific models

To check only specific models or scopes:

```
result = InvalidRecordFinder.call(models: [ImportantModel])
```

To check all models except some:

```
result = InvalidRecordFinder.call(
  ignored_models:     [HugeTableThing, IrrelevantThing],
  ignored_namespaces: 'Legacy::',
)
```

### Other options

Findings can also be put into CSV files.

The files will be in `Rails.root.join('tmp', 'invalid_records')` by default.

```
InvalidRecordFinder.call.save_csvs
```

Per default, there is one mail or CSV for each model with invalid records.

To send just a single mail or write a single CSV:

```
result = InvalidRecordFinder.call.flatten
result.mail(from: 'noreply@myapp.com', to: 'devs@myapp.com')
result.save_csvs(to: my_custom_dir)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/betterplace/invalid_record_finder.

## License

`InvalidRecordFinder` is released under the [Apache License 2.0](LICENSE.txt) and Copyright 2021 [gut.org gAG](https://gut.org).

