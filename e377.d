//https://redd.it/bazy5j
import std.stdio;
import std.array;
import std.range;
import std.algorithm;

void main()
{
}

ulong fit(ulong[] dimensions, ulong[] boxes)
{
    return zip(dimensions, boxes).map!(z => z[0] / z[1]).reduce!"a * b";
}

ulong fit1(ulong X, ulong Y, ulong x, ulong y)
{
    return fit([X, Y], [x, y]);
}

unittest
{
    assert(fit1(25, 18, 6, 5) == 12);
    assert(fit1(10, 10, 1, 1) == 100);
    assert(fit1(12, 34, 5, 6) == 10);
    assert(fit1(12345, 678910, 1112, 1314) == 5676);
    assert(fit1(5, 100, 6, 1) == 0);
}

ulong fit2(ulong X, ulong Y, ulong x, ulong y)
{
    return max(fit([X, Y], [x, y]), fit([X, Y], [y, x]));
}

unittest
{
    assert(fit2(25, 18, 6, 5) == 15);
    assert(fit2(12, 34, 5, 6) == 12);
    assert(fit2(12345, 678910, 1112, 1314) == 5676);
    assert(fit2(5, 5, 3, 2) == 2);
    assert(fit2(5, 100, 6, 1) == 80);
    assert(fit2(5, 5, 6, 1) == 0);
}

ulong fitn(ulong[] dimensions, ulong[] boxes)
{
    return boxes.permutations.map!(p => fit(dimensions, p.array)).reduce!max;
}

unittest
{
    assert(fitn([123, 456, 789, 1011, 1213, 1415], [16, 17, 18, 19, 20, 21]) == 1883443968);
    assert(fitn([123, 456, 789], [10, 11, 12]) == 32604);
    assert(fitn([3, 4], [1, 2]) == 6);
}
