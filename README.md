# Pregel

A single-node implementation of Google's Pregel framework for large-scale graph processing. It does not provide any of the distributed components, but implements the core functional pieces within a single Ruby VM such that you can develop and run iterative graph algorithms as if you had the full power of Pregel at your disposal.

To learn more about Pregel see following resources:

 * [Pregel, a system for large-scale graph processing](http://portal.acm.org/citation.cfm?id=1582716.1582723)
 * [Large-scale graph computing at Google](http://googleresearch.blogspot.com/2009/06/large-scale-graph-computing-at-google.html)
 * [Phoebus](http://github.com/xslogic/phoebus) is a distributed Erlang implementation of Pregel

# PageRank example with Pregel
To run a PageRank computation on an arbitrary graph, you simply specify the vertices & edges, and then define a compute function for each vertex. The coordinator then partitions the work between a specified number of workers (Ruby threads, in our case), and iteratively executes "supersteps" until we converge on a result. At each superstep, the vertex can read and process incoming messages and then send messages to other vertices. Hence, the full PageRank implementation is:

    class PageRankVertex < Vertex
      def compute
        if superstep >= 1
          sum = messages.inject(0) {|total,msg| total += msg; total }
          @value = (0.15 / num_nodes) + 0.85 * sum
        end

        if superstep < 30
          deliver_to_all_neighbors(@value / neighbors.size)
        else
          halt
        end
      end
    end

The above algorithm will run for 30 iterations, at which point all vertices will mark themselves as inactive and the coordinator will terminate our computation.

# License

(The MIT License)

Copyright (c) 2010 Ilya Grigorik

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.