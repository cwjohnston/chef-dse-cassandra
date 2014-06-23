cassandra-test
=============

[![Build Status](https://travis-ci.org/hw-cookbooks/cassandra-test.png?branch=master)](https://travis-ci.org/hw-cookbooks/cassandra-test)

Quick Start
-----------


Attributes
----------

* `node['cassandra-test']['option']` – Description of option. *(default: something)*

Resources
---------

### cassandra_test

The `cassandra_test` resource defines a something.

```ruby
cassandra_test 'name' do
  option 'a'
end
```

* `option` – Description of option. *(default: node['cassandra-test']['option'])*
