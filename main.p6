use v6.c;
use lib '.';
#use lib './lib/';

use lib::Tools;

# forward declare class
#class Node {...}

class NodeLayer
{
    has Vector $.nodeOuts;
    has Matrix $.weights;
    has Num $.bias;

    method new(Vector $nodeOuts, Matrix $weights, Num $bias)
    {
        return self.bless(:$nodeOuts, :$weights, :$bias);
    }

    method calc_val(Vector $prevLayerOuts)
    {
         $.nodeOuts = sigmoid ($prevLayerOuts * $.weights);
    }

    method calculateWeightDeltas(@input, @expected)
    {
    }
}

class trainingData
{
    has @.inputs;
    has @.expected;

    method New(@inputs, @expected)
    {
        return self.bless(:@inputs, :@expected);
    }
}

# delta * previous node = dcost/dweight
sub get_layer_weight_dels(@expected, NodeLayer $layer, NodeLayer $prevLayer, @prevDeltas = Nil)
{
    my @out = NodeLayer.nodeOuts.values;
    return if (@out.elems != @expected.elems);
    if (@prevDeltas == Nil)
    {
        my @deltas = do for (0..@expected.elems) -> i {
            -(@expected[i]-@out[i])*@out[i](1-@out[i])
        }

    }
    else
    {

    }
}

sub createRandList($size, $range)
{
    return do for (0..$size)
    {
        $range.rand
    }
}

sub createRandomMatrix ($dims, $range)
{
    my @split = $dims.split('x');
    die "Bad dim parameter <$dims> ex: 4x4" if @split.elems != 2;


    my $rows = (Int)(@split[0]);
    my $columns = (Int)(@split[1]);
    
    return Matrix.new(createRandList($rows*$columns,$range), $dims);
}

my @xorTraining = [trainingData.New([0,0],[0]),trainingData.New([0,1],[1]),trainingData.New([0,1],[1]),trainingData.New([1,0],[1]),trainingData.New([1,1],[0])];

sub MAIN()
{
    my NodeLayer $firstLayer = NodeLayer.new(Vector.new([0,0]),createRandomMatrix('2x2',(-1..1)),(-1..1).rand);
    my NodeLayer $outputLayer = NodeLayer.new(Vector.new([0,0]),createRandomMatrix('2x2',(-1..1)),(-1..1).rand);

    my @network = ($firstLayer, $outputLayer);

    #Training
    #{{{

    for @xorTraining
    {
        my $input = Vector.new($_.inputs);
        my $expected = Vector.new($_.expected);

        #get values for training
        for (0..@network.elems) -> i
        {
            if (i == 0){
                @network[i].calc_val($input);
            }
            else
            {
                @network[i].calc_val(@network[i-1]);
            }
        }

        # *-1 = -> $n { $n - 1 }
        my Matrix $weightDeltas = get_layer_weight_dels(@expected, @network[*-1], @network[*-2));
        

    }

    
    #}}}


}

#sub backProp (Node @lastRow, Num @expectedVal)
#{
#    return False if @lastRow.elems != @expectedVal.elems;
#
#    #dcost/dweight = dTotCost/dnode dnode/dTotInput dTotInput/dnodeWeight
#
#    # Gradient decent for output nodes
#    for (0..@lastRow.elems) -> $i
#    {
#        my $pd_cost_wrt_nodeVal = -(@expectedVal[$i] - @lastRow[$i]); 
#        my $pd_nodeVal_wrt_netInputToNode = @lastRow[$i] * (1 - @lastRow[$i]);
#        my @pd_netInputNode_wrt_weight = do for (@lastRow[$i].connections){ $_.val };
#        for (0..@lastRow[$i].connections.elems) ->$ii
#        {
#            
#        }
#    }
#}

#sub costFunction(Node @lastRow, @expectedVals)
#{
#    my @lastRowVals = do {
#        $_.val for @lastRow;
#    }
#
#    return [+] (@expectedVals <<->> @lastRow).map: { ^2/2};
#}
