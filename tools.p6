

class Matrix
{
    has Int $.columns;
    has Int $.rows;
    has @.values;

    method new(@values, $columns)
    {
        #if @vals[0] is array
        # flatten this and get columns val from that
        # default columns to zero meaning that its a non flat array
        my $rows = (Int)(@values.elems/$columns);
        return self.bless(:@values, :$columns, :$rows);
    }

}

class Vector
{
    has Int $.dims;
    has @.values is rw;

    method gradient()
    {
        
    }
}

sub sigmoid (Num $in) returns Num
{
    return 1/(1+e**-$in);
}

multi sub infix:<*>(Matrix $lhs, Vector $rhs)
{
    die "Vector and matrix have different dims" if $lhs.columns != $rhs.values.elems;
    return do loop (my $i=0; $i < $lhs.values.elems; $i += $lhs.columns)
    {
        [+]($lhs.values[$i..$i+$lhs.columns-1] <<*>> $rhs.values)
    }
}

multi sub infix:<*>(Vector $lhs, Matrix $rhs)
{
    $rhs * $lhs;
}

my $test = Matrix.new([1,3,4,1,2,3],3);
my $vec = Vector.new();
$vec.values = [2,3,4];

say $test * $vec;
say $vec * $test;
say [2,3,4] <<*>> [1,3,4];
