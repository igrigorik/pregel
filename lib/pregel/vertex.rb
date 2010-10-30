module Pregel
  class Vertex
    attr_reader :id
    attr_accessor :value

    def initialize(id, value, *outedges)
      @id = id
      @value = value
      @outedges = outedges
      @active = true
    end

    def edges
      block_given? ? @outedges.each {|e| yield e} : @outedges
    end

    def compute; raise "undefined compute function"; end

    def halt; @active = false; end
    def active?; @active; end
  end
end