Bugsnag notifier for EventMachine
=================================

The Bugsnag notifier for EventMachine makes it easy to track errors and exceptions inside EventMachine, no matter how many callbacks or deferrables you're using!

How to Install
--------------

1. Add the `bugsnag-em` gem to your `Gemfile`

   ```ruby
   gem "bugsnag-em"
   ```

2. Install the gem

   ```shell
   bundle install
   ```

3. Configure the Bugsnag module with your API key

   ```ruby
   Bugsnag.configure do |config|
     config.api_key = "YOUR_API_KEY_HERE"
   end
   ```

   If you don't configure the api_key, the Bugsnag module will read the
   `BUGSNAG_API_KEY` environment variable.

Sending custom data with exceptions
-----------------------------------

The hardest part of handling asynchronous exceptions is to keep track of the context in which they are running. `bugsnag-em` uses [LSpace](https://github.com/ConradIrwin/lspace) under the hood to do so. This enables us to track which contexts callbacks happen in so we don't get muddled by concurrent requests.

To set data for a context, you can use `Bugsnag.with`

```ruby
Bugsnag.with(user: {id: '123'}) do
  http = EM::HttpRequest.new('http://google.com/').get
  http.errback{ raise 'oops' }
  ...
end
```

The exception raised in the http callback will be sent to Bugsnag with the user id 123, so you can debug more easily.

Keeping the event loop alive
----------------------------

By default EventMachine terminates the event loop on any unhandled exception. This is to avoid memory leaks caused by crashed connections that will never progress, and callbacks that will never be called.

If you would like to keep the event loop alive, and you are sure you can clean up from unhandled exceptions sufficiently, you can use LSpace to add your own exception handler. If you do this then you should either call `Bugsnag.notify` yourself, or re-raise the exception to ensure that the exception reaches Bugsnag.

```ruby
LSpace.rescue do |e|
  raise unless LSpace[:current_connection]
  puts "Exception in #{LSpace[:session_id]}"
  puts e
  Bugsnag.notify e
  cleanup_connection LSpace[:current_connection]
end
```

Further details
---------------

For further information about the Bugsnag ruby notifier, please see its [README](https://github.com/bugsnag/bugsnag-ruby)


Reporting Bugs or Feature Requests
----------------------------------

Please report any bugs or feature requests on the github issues page for this
project here:

<https://github.com/bugsnag/bugsnag-em/issues>


Contributing
------------

-   [Fork](https://help.github.com/articles/fork-a-repo) the [notifier on github](https://github.com/bugsnag/bugsnag-em)
-   Commit and push until you are happy with your contribution
-   Run the tests with `rake spec` and make sure they all pass
-   [Make a pull request](https://help.github.com/articles/using-pull-requests)
-   Thanks!


Build Status
------------
[![Build Status](https://secure.travis-ci.org/bugsnag/bugsnag-em.png)](http://travis-ci.org/bugsnag/bugsnag-em)


License
-------

The Bugsnag EventMachine notifier is free software released under the MIT License.
See [LICENSE.TXT](https://github.com/bugsnag/bugsnag-em/blob/master/LICENSE.MIT) for details.
