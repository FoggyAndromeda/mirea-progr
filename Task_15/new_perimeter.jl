include("..\\types_and_structs.jl")
#TODO: comments
function perimeter(robot::Robot)
    r = BorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)
    for direction in [Nord, Ost, Sud, West]
        move_until_border!(r, direction, fill = true)
        if !ismarker(r)
            putmarker!(r)
        end
    end
    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
end

r = Robot("perimeter.sit", animate=true)
perimeter(r)