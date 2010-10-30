require 'helper'

describe Worker do

  let(:graph) do
    [
      AddVertex.new(:igvita,     1,  :wikipedia),
      AddVertex.new(:wikipedia,  2,  :google),
      AddVertex.new(:google,     1,  :wikipedia)
    ]
  end

  let(:worker) do
    Worker.new(graph)
  end

  it 'should accept non-zero number of nodes' do
    lambda { Worker.new([]) }.should raise_error
  end

  it 'should partition graphs with variable worker sizes' do
    graph = [
      Vertex.new(:igvita,     1,  :wikipedia),
      Vertex.new(:wikipedia,  2,  :google),
      Vertex.new(:google,     1,  :wikipedia)
    ]

    c = Coordinator.new(graph)
    c.workers.size.should == 1

    c = Coordinator.new(graph, partitions: 2)
    c.workers.size.should == 2
  end

  it 'should execute an async superstep' do
    # TODO: simulate async message delivery to worker by returning
    # a thread per message
    worker.superstep.should be_an_instance_of Thread
  end

  it 'should perform single iteration on the graph' do
    # TODO: reuse a threadpool within worker for each partition
    worker.superstep.join
    worker.vertices.first.value.should == 2
  end

  it 'should return the number of active vertices for next superstep' do
    worker.superstep.join
    worker.active.should > 0
  end

  it 'should deliver messages to vertices at beginning of each superstep' do
    PostOffice.instance.deliver(:igvita, 'hello')
    worker.superstep.join

    ig = worker.vertices.find {|v| v.id == :igvita }
    ig.messages.size.should == 1
    ig.messages.first.should == 'hello'
  end

end
