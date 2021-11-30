using HorizonSideRobots
include("..\\movement_patterns_lib.jl")

#TODO: comments

function count_horizontal_borders(r::Robot)
    left = move_until_border!(r, West)
    down = move_until_border!(r, Sud)

    ans = 0
    while !isborder(r, Nord)
        mode = 0
        while !isborder(r, Ost)
            move!(r, Ost)
            if isborder(r, Nord) && mode == 0
                mode = 1
            elseif !isborder(r, Nord) && mode == 1
                ans += 1
                mode = 0
            end
        end
        move_until_border!(r, West)
        move!(r, Nord)
    end

    move_until_border!(r, Sud)
    do_n_steps!(r, Nord, down)
    do_n_steps!(r, Ost, left)
    return ans
end
