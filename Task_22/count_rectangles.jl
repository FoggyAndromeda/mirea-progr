include("..\\types_and_structs.jl")

#TODO: comments
function count_rect(robot::Robot)
    r = CoordBorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)
    width = move_until_border!(r, Ost)
    do_n_steps!(r, West, width)
    height = move_until_border!(r, Nord)
    do_n_steps!(r, Sud, height)
    data = zeros(Int8, width + 1, height + 1)
    set_coords(r.coord, 1, 1)
    for i in 1:width
        data[i, 1] = -1
    end
    for i in 1:height + 1
        data[1, i] = -1
        while try_move!(r, Ost) != 0
            x, y = get_coords(r.coord)
            data[x, y] = -1
        end
        move_until_border!(r, West)
        try_move!(r, Nord)
    end
    now_comp = 1
    function dfs(x, y)
        if data[x, y] == -1 || data[x, y] == now_comp || x < 1 || x > width || y < 1 || y > height
            return 0
        end
        data[x, y] = now_comp
        dfs(x + 1, y)
        dfs(x - 1, y)
        dfs(x, y + 1)
        dfs(x, y - 1)
    end
    for i in 1:width
        for j in 1:height
            if data[i, j] == 0
                dfs(i, j)
                now_comp += 1
            end
        end
    end
    move_until_border!(r, West)
    move_until_border!(r, Sud)
    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
    return now_comp - 1
end

r = Robot("count_rectangles.sit")
println(count_rect(r))