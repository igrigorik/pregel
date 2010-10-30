module Pregel
  class Vertex
    attr_reader :id, :superstep
    attr_accessor :value

    def initialize(id, value, *outedges)
      @id = id
      @value = value
      @outedges = outedges
      @active = true
      @superstep = 0
    end

    def edges
      block_given? ? @outedges.each {|e| yield e} : @outedges
    end

    def step
      @superstep += 1
      compute
    end

    def compute; end

    def halt; @active = false; end
    def active?; @active; end
  end
end
