require 'eventmachine'
require 'lspace/eventmachine'
require 'bugsnag'

class << Bugsnag
  # With let's you set parameters on future calls to Bugsnag.notify.
  #
  # It uses LSpace to track this data through asynchronous jumps (like
  # making an HTTP request or setting a timer) so that it can be used
  # in a fully eventmachine context.
  #
  # @param [Object] overrides. @see Bugsnag.notify
  #
  # @example
  #   Bugsnag.with(user: {id: 'max'}, connection: {remote_ip: '127.0.0.1'}) do
  #     EM::next_tick do
  #       raise 'oops'
  #     end
  #   end
  #
  def with(overrides, &block)
    overrides = (LSpace[:bugsnag] || {}).merge overrides
    LSpace.with(bugsnag: overrides, &block)
  end

  alias_method :notify_without_lspace, :notify
  def notify(exception, overrides=nil, request_data=nil)
    overrides = LSpace[:bugsnag].merge(overrides || {}) if LSpace[:bugsnag]
    notify_without_lspace exception, overrides, request_data
  end

  alias_method :auto_notify_without_lspace, :auto_notify
  def auto_notify(exception, overrides=nil, request_data=nil)
    overrides = LSpace[:bugsnag].merge(overrides || {}) if LSpace[:bugsnag]
    overrides = overrides.merge({
      :severity_reason => {
        :type => "middleware_handler",
        :attributes => {
          :name => "eventmachine"
        }
      }
    })
    auto_notify_without_lspace exception, overrides, request_data
  end
end

if EM::reactor_running?
  raise "Please require em-bugsnag before starting the reactor"
end

LSpace.rescue Exception do |e|
  Bugsnag.auto_notify e
  raise
end
