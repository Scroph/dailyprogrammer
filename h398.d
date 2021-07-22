//https://www.reddit.com/r/dailyprogrammer/comments/oirb5v/20210712_challenge_398_difficult_matrix_sum/
import std.algorithm : map, sum, makeIndex;
import std.functional : memoize;

unittest
{
    immutable(ulong)[][] input = [
        [123456789,   752880530,   826085747,  576968456,   721429729],
        [173957326,   1031077599,  407299684,  67656429,    96549194],
        [1048156299,  663035648,   604085049,  1017819398,  325233271],
        [942914780,   664359365,   770319362,  52838563,    720059384],
        [472459921,   662187582,   163882767,  987977812,   394465693]
    ];

    log("5x5");
    ulong sum = input.findMinSum();
    log(1099762961, " == ", sum);
    assert(1099762961 == sum);
}

unittest
{
    import std : splitter, array, to, File, strip, map, sum;

    immutable(ulong)[][] matrix;
    auto input = File("input");
    foreach(line; input.byLine)
    {
        immutable(ulong)[] row = line.strip().splitter(" ").map!(to!ulong).array;
        matrix ~= row;
    }

    log("20x20");
    ulong result = matrix.findMinSum();
    assert(1314605186 == result);
    assert(35 == result.to!string.map!(c => c - '0').sum());
}

ulong findMinSum(immutable(ulong)[][] input)
{
    bool[Cell] current;
    bool[ulong] occupiedRows;
    bool[ulong] occupiedColumns;
    ulong currentMin = ulong.max;
    findMinSumHelper(input, current, occupiedRows, occupiedColumns, 0, currentMin);
    return currentMin;
}

void findMinSumHelper(
    immutable(ulong)[][] input,
    ref bool[Cell] current,
    ref bool[ulong] occupiedRows,
    ref bool[ulong] occupiedColumns,
    ulong y,
    ref ulong currentMin
)
{
    if(y in occupiedRows)
    {
        return;
    }
    if(current.sum() > currentMin)
    {
        return;
    }
    if(y == input.length)
    {
        ulong newMin = current.sum();
        if(newMin < currentMin)
        {
            log("New minimum : ", newMin);
            currentMin = newMin;
        }
        return;
    }
    immutable row = input[y];
    ulong[] sortedIndexes = row.getSortedIndexesWithCaching();

    foreach(x; sortedIndexes)
    {
        ulong cell = row[x];
        if(x in occupiedColumns)
        {
            continue;
        }
        current[Cell(x, y, cell)] = true;
        occupiedRows[y] = true;
        occupiedColumns[x] = true;

        findMinSumHelper(input, current, occupiedRows, occupiedColumns, y + 1, currentMin);

        current.remove(Cell(x, y, cell));
        occupiedRows.remove(y);
        occupiedColumns.remove(x);
    }
}

alias getSortedIndexesWithCaching = memoize!getSortedIndexes;
ulong[] getSortedIndexes(immutable ulong[] row)
{
    ulong[] sortedIndexes = new ulong[row.length];
    makeIndex!("a < b")(row, sortedIndexes);
    return sortedIndexes;
}

ulong sum(bool[Cell] solution)
{
    return solution.byKey.map!(cell => cell.value).sum();
}

bool contains(bool[Cell] solution, ulong x, ulong y)
{
    foreach(cell, _; solution)
    {
        if(cell.x == x || cell.y == y)
        {
            return true;
        }
    }
    return false;
}

struct Cell
{
    ulong x;
    ulong y;
    ulong value;
}

void log(S...)(S args)
{
    debug
    {
        import std.stdio : writeln;
        writeln(args);
    }
}

void main()
{
    return;
    import std : splitter, array, to, File, strip, map, sum, writeln;

    immutable(ulong)[][] matrix;
    auto input = File("input-large.txt");
    foreach(line; input.byLine)
    {
        immutable(ulong)[] row = line.strip().splitter(" ").map!(to!ulong).array;
        matrix ~= row;
    }

    ulong result = matrix.findMinSum();
    writeln("Large : ", result);
}
