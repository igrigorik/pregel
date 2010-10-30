require 'pregel/vertex'
require 'pregel/worker'
require 'pregel/coordinator'

require 'singleton'

class PostOffice
  include Singleton

  def initialize
    @mailboxes = Hash.new
    @mutex = Mutex.new
  end

  def deliver(to, msg)
    @mutex.synchronize do
      if @mailboxes[to]
        @mailboxes[to].push msg
      else
        @mailboxes[to] = [msg]
      end
    end
  end

  def read(box)
    @mutex.synchronize do
      msgs = @mailboxes[box] || []
      @mailboxes.clear
      msgs
    end
  end
end
