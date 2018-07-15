import std.stdio;
import std.math : abs;
import std.conv;
import std.string;
import std.range;
import std.algorithm;
import std.array;

dchar[dchar] right_rotations, left_rotations;

static this()
{
    right_rotations = [
        '#': '#', '^': '>', '>': 'v',
        'v': '<', '<': '^', '-': '|',
        '|': '-', '\\': '/', '/': '\\',
    ];
    left_rotations = [
        '#': '#', '>': '^', 'v': '>',
        '<': 'v', '^': '<', '|': '-',
        '-': '|', '\\': '/', '/': '\\',
    ];
}

void main()
{
    int angle, size;
    dchar[][] tile;
    readf!"%d %d "(angle, size);
    tile.reserve(size);
    foreach(y; 0 .. size)
        tile ~= readln.strip.dup.map!(to!dchar).array;

    int limit = 3;
    auto board = initialized_matrix(size * limit, cast(dchar) '?');
    foreach(i; 0 .. limit)
        foreach(j; 0 .. limit)
            board.place(i * size, j * size, tile.rotate(angle * (i + j)));
    board.draw;
}

void draw(dchar[][] board)
{
    board.each!writeln;
}

dchar[][] initialized_matrix(int size, dchar value = dchar.init)
{
    dchar[][] matrix;
    matrix.reserve(size);
    foreach(i; 0 .. size)
        matrix ~= value.repeat.take(size).array;
    return matrix;
}

void place(dchar[][] board, int x, int y, dchar[][] tile)
{
    foreach(_y; 0 .. tile.length)
        foreach(_x; 0 .. tile.length)
            board[y + _y][x + _x] = tile[_y][_x];
}

dchar rotate_right(dchar character)
{
    return right_rotations.get(character, character);
}

dchar rotate_left(dchar character)
{
    return left_rotations.get(character, character);
}

dchar[][] rotate_right(dchar[][] input)
{
    dchar[][] result;
    foreach(row; input.dup.retro.transposed)
        result ~= row.map!rotate_right.array;
    return result;
}

dchar[][] rotate_left(dchar[][] input)
{
    dchar[][] result;
    foreach(row; input.dup.transposed.map!array.array.retro)
        result ~= row.map!rotate_left.array;
    return result;
}

dchar[][] rotate(dchar[][] input, int angle)
{
    if(angle.abs % 90 != 0)
        throw new Exception("angle must be a multiple of 90 : " ~ angle.to!string);
    auto matrix = input;
    for(int i = 0; i < angle.abs / 90; i++)
        matrix = angle < 0 ? matrix.rotate_left : matrix.rotate_right;
    return matrix;
}

unittest
{
    auto matrix = to!(dchar[][])([
        ['1', '2', '3'],
        ['4', '5', '6'],
        ['7', '8', '9']
    ]);

    assert(matrix.rotate_right == to!(dchar[][])([
        ['7', '4', '1'],
        ['8', '5', '2'],
        ['9', '6', '3']
    ]));

    assert(matrix.rotate(180) == matrix.rotate(-180));
    assert(matrix.rotate(270) == to!(dchar[][])([
        ['3', '6', '9'],
        ['2', '5', '8'],
        ['1', '4', '7'],
    ]));

    assert(matrix.rotate(-90) == to!(dchar[][])([
        ['3', '6', '9'],
        ['2', '5', '8'],
        ['1', '4', '7'],
    ]));

    import std.exception : assertThrown;
    assertThrown(matrix.rotate(333));
    assertThrown(matrix.rotate(-333));
}
