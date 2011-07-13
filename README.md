Refining
========

Stupid and ugly method refining, used in failirc and packø

```ruby
class String
  refine_method :length do |old|
    puts old.call
    old.call
  end
end

"lol".length # => this will puts the length and return it
```

You can also refine methods on already created objects or refine class methods.
