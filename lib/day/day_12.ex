defmodule AOC.Day12 do
  def solve_part1(input \\ nil) do
    parse(input)
    |> get_region_area_and_perimeter()
    |> elem(1)
  end

  def solve_part2(input \\ nil) do
    parse(input)
    |> get_region_area_and_sides()
    |> elem(1)
  end

  defp get_region_area_and_perimeter(grid) do
    seen = MapSet.new()

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(hd(grid)) - 1),
        reduce: {seen, 0} do
      {seen, answer} ->
        region = GridUtils.cell_value({row, col}, grid)

        if not MapSet.member?(seen, {row, col}) do
          {seen, region_area, region_perimiter} =
            get_region_area_and_perimeter(grid, region, {row, col}, seen)

          {seen, answer + region_area * region_perimiter}
        else
          {seen, answer}
        end
    end
  end

  defp get_region_area_and_perimeter(grid, region, position, seen) do
    if MapSet.member?(seen, position) do
      {seen, 0, 0}
    else
      seen = MapSet.put(seen, position)

      {region_neighbors, other_neighbors} =
        Enum.split_with(GridUtils.get_neighbors(position), fn neighbor_position ->
          GridUtils.in_bound?(neighbor_position, grid) and
            GridUtils.cell_value(neighbor_position, grid) == region
        end)

      remaining_to_check = Enum.filter(region_neighbors, &(not MapSet.member?(seen, &1)))

      {seen, neighbor_area, neighbor_perimeter} =
        Enum.reduce(remaining_to_check, {seen, 0, 0}, fn neighbor_position,
                                                         {seen, area, perimeter} ->
          {seen, neighbor_area, neighbor_perimeter} =
            get_region_area_and_perimeter(grid, region, neighbor_position, seen)

          {seen, area + neighbor_area, neighbor_perimeter + perimeter}
        end)

      {seen, neighbor_area + 1, neighbor_perimeter + length(other_neighbors)}
    end
  end

  defp get_region_area_and_sides(grid) do
    seen = MapSet.new()

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(hd(grid)) - 1),
        reduce: {seen, 0} do
      {seen, answer} ->
        region = GridUtils.cell_value({row, col}, grid)

        if not MapSet.member?(seen, {row, col}) do
          {seen, region_area, region_sides} =
            get_region_area_and_sides(grid, region, {row, col}, seen)

          {seen, answer + region_area * region_sides}
        else
          {seen, answer}
        end
    end
  end

  defp get_region_area_and_sides(grid, region, position, seen) do
    if MapSet.member?(seen, position) do
      {seen, 0, 0}
    else
      seen = MapSet.put(seen, position)

      [up, down, left, right, _, _, _, _] = neighbors = GridUtils.get_all_neighbors(position)

      region_neighbors =
        Enum.filter([up, down, left, right], fn neighbor_position ->
          GridUtils.in_bound?(neighbor_position, grid) and
            GridUtils.cell_value(neighbor_position, grid) == region
        end)

      remaining_to_check = Enum.filter(region_neighbors, &(not MapSet.member?(seen, &1)))
      corner_count = region_corner_count(region, neighbors, grid)

      {seen, neighbor_area, neighbor_sides} =
        Enum.reduce(remaining_to_check, {seen, 0, 0}, fn neighbor_position, {seen, area, size} ->
          {seen, neighbor_area, neighbor_sides} =
            get_region_area_and_sides(grid, region, neighbor_position, seen)

          {seen, area + neighbor_area, neighbor_sides + size}
        end)

      {seen, neighbor_area + 1, neighbor_sides + corner_count}
    end
  end

  defp region_corner_count(region, neighbors, grid) do
    [u, d, l, r, ul, ur, dl, dr] = neighbors
    external_corner_checks = [{u, l}, {u, r}, {d, l}, {d, r}]
    internal_corner_checks = [{u, l, ul}, {u, r, ur}, {d, l, dl}, {d, r, dr}]

    bounds = GridUtils.get_bounds(grid)

    internal_corners =
      Enum.filter(internal_corner_checks, fn {vert, hori, diag} ->
        in_bound = Enum.all?([vert, hori, diag], &GridUtils.in_bound?(&1, bounds))

        if in_bound do
          Enum.all?([vert, hori], &(GridUtils.cell_value(&1, grid) == region)) and
            GridUtils.cell_value(diag, grid) != region
        else
          false
        end
      end)

    outside_corners =
      Enum.reject(external_corner_checks, fn {edge1, edge2} ->
        (GridUtils.in_bound?(edge1, bounds) and GridUtils.cell_value(edge1, grid) == region) or
          (GridUtils.in_bound?(edge2, bounds) and
             GridUtils.cell_value(edge2, grid) == region)
      end)

    length(outside_corners) + length(internal_corners)
  end

  defp parse(input) do
    AOC.get_input(12, input)
    |> String.split("\n", trim: true)
    |> Enum.reduce([], &(&2 ++ [String.graphemes(&1)]))
  end
end
