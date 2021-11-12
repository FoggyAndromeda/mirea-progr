include("..\\types_and_structs.jl")

#TODO: commets
function fill(robot::Robot)
    r = BorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)
    fill_rec(get(r))
    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
end

function fill_rec(r::Robot)
    putmarker!(r)
    for direction in [Nord, Ost]
        if !isborder(r, direction)
            move!(r, direction)
            if !ismarker(r)
                fill_rec(r)
            end
            move!(r, opposite_direction(direction))
        end
    end
end
