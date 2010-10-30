module Pregel
  class Worker
    attr_reader :vertices, :active

    def initialize(graph = [])
      raise 'empty worker graph' if graph.empty?
      @vertices = graph
      @active   = graph.size
    end

    def superstep
      Thread.new do
        active = @vertices.select {|v| v.active?}
        active.each {|v| v.compute}

        @active = active.select {|v| v.active?}.size
      end
    end
  end
end
