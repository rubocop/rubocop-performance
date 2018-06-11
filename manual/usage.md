You need to tell RuboCop to load the Performance extension. There are three
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yml
require: rubocop-performance
```

Now you can run `rubocop` and it will automatically load the RuboCop Performance
cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-performance
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-performance'
end
```

