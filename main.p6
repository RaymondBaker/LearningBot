use v6.c;

require 'tools.p6';

class Connection
{
    # backwards
    has Node $.node;
    has Num $.weight;
}

class Node
{
    has Connection @.connections; 
    has Num $.val;
    
    method New(Node @connections,Num @weights)
    {
        return self.Bless(:@connections, :@weights);
    }

    method calculateVal()
    {
        return sigmoid ([+] do {
                $con.weight * $con.node.val for Connection $con in @.connections;
        })
    }
}

sub costFunction(Node @lastRow, @expectedVals)
{
    my lastRowVals = do {
        @lastRow.val;
    }
}


sub MAIN()
{

}
