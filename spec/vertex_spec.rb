require 'helper'

include Pregel

describe Vertex do
  it 'should create a vertex with id, value, and edges' do
    lambda { Vertex.new(:a, 10, :b) }.should_not raise_error
    lambda { Vertex.new(:a, 10, :b, :c) }.should_not raise_error
  end

  let(:v) { Vertex.new(:a, 10, :b, :c) }

  it 'should report new vertex as active' do
    v.active?.should be_true

    v.halt
    v.active?.should be_false
  end

  it 'should contain a modifiable value' do
    v.value = 20
    v.value.should == 20
  end

  it 'should allow iterating over out-edges' do
    v.edges.size.should == 2
    v.edges.each {|e| [:b, :c].should include e }
  end

  it 'should allow arbitrary type for edge' do
    lambda do
      Vertex.new(:a, 10, {id: 1, weight:10}, {id: 2, weight:20})
    end.should_not raise_error
  end

  it 'should allow a user defined compute' do
    class V < Vertex
      def compute; @value = 20; end
    end

    v = V.new(:a, 10)
    v.compute
    v.value.should == 20
  end

  it 'should be able to send messages' do
    class V < Vertex
      def compute
        deliver(:a, :b)
      end
    end

    lambda do
      v = V.new(:a, 10)
      v.compute
    end.should_not raise_error
  end
end
