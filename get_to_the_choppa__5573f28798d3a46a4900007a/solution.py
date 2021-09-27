from typing import Dict, Iterable, List, NamedTuple, Set, TYPE_CHECKING

if TYPE_CHECKING:
    class Position(NamedTuple):
        x: int
        y: int

    class Node(NamedTuple):
        position: Position
        passable: bool


class Node(object):
    def __init__(self, position, passable=True):
        self.position = position
        self.passable = passable

    def __repr__(self):
        return self.position.__repr__()


class Position(NamedTuple):
    x: int
    y: int

    def __repr__(self):
        return f'({self.x},{self.y})'


def get_neighbors(grid: List[List[Node]], node: Node) -> Iterable[Node]:
    x, y = node.position.x, node.position.y
    for dx, dy in (0, -1), (1, 0), (0, 1), (-1, 0):
        nx, ny = x + dx, y + dy
        if 0 <= nx < len(grid) and 0 <= ny < len(grid[0]):
            yield grid[nx][ny]


def find_shortest_path(grid: List[List[Node]], start_node: Node, end_node: Node) -> List[Node]:
    if not grid:
        return []

    queue: Set[Node] = {start_node}
    out: Set[Node] = set()
    scores: Dict[Node, int] = {start_node: 0}
    min_source: Dict[Node, Node] = {}

    while queue:
        node = queue.pop()
        if node is end_node:
            break

        node_score = scores[node] + 1

        for neighbor in get_neighbors(grid, node):
            if neighbor in out:
                continue
            if not neighbor.passable:
                out.add(neighbor)
                continue

            neighbor_score = scores.get(neighbor, float('Inf'))
            if node_score < neighbor_score:
                scores[neighbor] = node_score
                min_source[neighbor] = node

            queue.add(neighbor)

        out.add(node)

    path = [end_node]
    node = end_node
    while True:
        if node in min_source:
            node = min_source[node]
            path.append(node)
        else:
            break

    return path[::-1]
