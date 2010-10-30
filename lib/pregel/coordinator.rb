module Pregel
  class Coordinator
    attr_reader :workers

    def initialize(graph, options = {})
      raise "empty graph" if graph.empty?

      @workers = []
      @options = {
        :partitions => 1
      }.merge(options)

      partition(graph) do |subgraph|
        @workers << Worker.new(subgraph)
      end
    end

    def partition(graph)
      size = (graph.size.to_f / @options[:partitions]).ceil
      graph.each_slice(size) { |slice| yield slice }
    end

    def run
      loop do
        # execute a superstep and wait for workers to complete
        step = @workers.select {|w| w.active > 0}.collect {|w| w.superstep }
        step.each {|t| t.join}

        break if @workers.select {|w| w.active > 0}.size.zero?
      end
    end
  end
end
