require 'helper'

describe Coordinator do
  it 'should not allow empty graphs' do
    lambda { Coordinator.new([]) }.should raise_error
  end

  let(:graph) do
    [
      AddVertex.new(:igvita,     1,  :wikipedia),
      AddVertex.new(:wikipedia,  2,  :google),
      AddVertex.new(:google,     1,  :wikipedia)
    ]
  end

  it 'should partition graphs with variable worker sizes' do
    c = Coordinator.new(graph)
    c.workers.size.should == 1

    c = Coordinator.new(graph, partitions: 2)
    c.workers.size.should == 2
  end

  it 'should schedule workers to run until there are no active vertices' do
    c = Coordinator.new(graph)
    c.run

    c.workers.each do |w|
      w.vertices.each do |v|
        v.value.should == 5
      end
    end
  end

  context 'PageRank' do
    class PageRankVertex < Vertex
      def compute
        if superstep >= 1
          sum = messages.inject(0) {|total,msg| total += msg; total }
          @value = (0.15 / 3) + 0.85 * sum
        end

        if superstep < 30
          deliver_to_all_neighbors(@value / neighbors.size)
        else
          halt
        end
      end
    end


    it 'should calculate PageRank of a circular graph' do
      graph = [
        #                   name     value  out-edges
        PageRankVertex.new(:igvita,     1,  :wikipedia),
        PageRankVertex.new(:wikipedia,  1,  :google),
        PageRankVertex.new(:google,     1,  :igvita)
      ]

      c = Coordinator.new(graph)
      c.run

      c.workers.each do |w|
        w.vertices.each do |v|
          (v.value * 100).to_i.should == 33
        end
      end
    end

    it 'should calculate PageRank of arbitrary graph' do
      graph = [
        # page 1 -> page 1, page 2  (0.18)
        # page 2 -> page 1, page 3  (0.13)
        # page 3 -> page 3          (0.69)

        #                   name     value  out-edges
        PageRankVertex.new(:igvita,     1,  :igvita, :wikipedia),
        PageRankVertex.new(:wikipedia,  1,  :igvita, :google),
        PageRankVertex.new(:google,     1,  :google)
      ]

      c = Coordinator.new(graph)
      c.run

      c.workers.each do |w|
        (w.vertices.find {|v| v.id == :igvita }.value * 100).ceil.to_i.should == 19
        (w.vertices.find {|v| v.id == :wikipedia }.value * 100).ceil.to_i.should == 13
        (w.vertices.find {|v| v.id == :google }.value * 100).to_i.should == 68
      end
    end
  end

  it 'should parition nodes by hashing the node id'
  it 'should allow scheduling multiple partitions to a single worker'
end
