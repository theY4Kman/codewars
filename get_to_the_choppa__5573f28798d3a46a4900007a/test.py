from codewars_test import test_framework as test
from solution import find_shortest_path, Node, Position


def make_grid(grid_blueprint, width, height):
    """Convert a list of lists of 0's and 1's to a graph of Node objects"""
    grid_blueprint = grid_blueprint.strip().replace('\n', '')
    grid = []
    start_node, end_node = None, None
    for x in range(0, width):
        grid.append([])
        for y in range(0, height):
            char = grid_blueprint[y * width + x]
            node = Node(position=Position(x, y), passable=False if char == '1' else True)
            if char == 'S':
                start_node = node
            elif char == 'E':
                end_node = node
            grid[x].append(node)

    return grid, start_node, end_node


test.describe("Test Grid 1")
grid1_blueprint = """
S0110
01000
01010
00010
0001E
"""
grid1, grid1_start, grid1_target = make_grid(grid1_blueprint, 5, 5)
grid1_optimum_path = [
    grid1[0][0],
    grid1[0][1],
    grid1[0][2],
    grid1[0][3],
    grid1[1][3],
    grid1[2][3],
    grid1[2][2],
    grid1[2][1],
    grid1[3][1],
    grid1[4][1],
    grid1[4][2],
    grid1[4][3],
    grid1[4][4]
]
print(grid1_blueprint)
path = find_shortest_path(grid1, grid1_start, grid1_target)

if __name__ == '__main__':
    test.it("Check path")
    test.assert_equals(path, grid1_optimum_path, "Your path is not the shortest path. Try again!")
