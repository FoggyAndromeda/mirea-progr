include("..\\types_and_structs.jl")

#TODO: comments
function cross(robot::Robot)
    r = BorderRobot(robot)
    for i in 0:3
        steps = move_until_border!(r, HorizonSide(i), fill=true)
        do_n_steps_try!(r, opposite_direction(HorizonSide(i)), steps)
    end
    putmarker!(r)
end
