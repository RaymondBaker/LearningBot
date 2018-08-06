
unit module Tools;

class Matrix is export
{
    has Int $.columns;
    has Int $.rows;
    has @.values;

    multi method new(@values, $dims)
    {
        #if @vals[0] is array
        # flatten this and get columns val from that
        # default columns to zero meaning that its a non flat array
        #

        my @split = $dims.split('x');
        die "Bad dim parameter <$dims> ex: 4x4" if @split.elems != 2;


        my $rows = (Int)(@split[0]);
        my $columns = (Int)(@split[1]);

        die "more rows * columns is larger than array" if ($rows * $columns > @values.elems);

        return self.bless(:@values, :$columns, :$rows);
    }

    multi method new(@values, $rows, $columns)
    {
        return self.bless(:@values, :$columns, :$rows);
    }


}

#extend list for = to work?
class Vector is export
{
    has @.values is rw;

    method new(@values)
    {
        return self.bless(:@values);
    }

    method gradient()
    {
        
    }
}

sub clamp ($num, $upper,  $lower) is export
{
    return $upper if $num > $upper;
    return $lower if $num < $lower;
    return $num;
}

multi sub sigmoid (Num $num) is export
{
    my $clampedNum = clamp($num, 37, -37);
    return 1 / (1 + e**(-$clampedNum));
}

multi sub sigmoid (List $list) is export
{
    return do for ($list)
    {
        sigmoid($_)
    }
}

multi sub sigmoid (Vector $vector) is export
{
    return Vector,new(sigmoid ($vector.values));
}

multi sub infix:<->(Vector $lhs, Vector $rhs) is export
{
    die "Vectors are not the same length" if $lhs.values.elems != $rhs.values.elems;
    return $lhs.values <<->> $rhs.values;
}

#multi sub infix:<=>(Vector $lhs, List $rhs) is export
#{
#    $lhs.values = $rhs;
#}

multi sub infix:<*>(Matrix $lhs, Vector $rhs) is export
{
    die "Vector and matrix have different dims" if $lhs.columns != $rhs.values.elems;
    return Vector.new(do loop (my $i=0; $i < $lhs.values.elems; $i += $lhs.columns)
    {
        [+]($lhs.values[$i..$i+$lhs.columns-1] <<*>> $rhs.values)
    })
}

multi sub infix:<*>(Vector $lhs, Matrix $rhs) is export
{
    $rhs * $lhs;
}

#my $test = Matrix.new([1,3,4,1,2,3],3);
#my $vec = Vector.new();
#$vec.values = [2,3,4];
#
#say $test * $vec;
#say $vec * $test;
#say [2,3,4] <<*>> [1,3,4];
