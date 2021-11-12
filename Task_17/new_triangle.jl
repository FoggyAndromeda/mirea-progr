include("..\\types_and_structs.jl")

#TODO: comments
function triangle(robot::Robot)
    r = BorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)
    width = move_until_border!(r, Ost)
    move_until_border!(r, West)
    while (width > -1)
        putmarker!(r)
        delta = 0
        for i in 1:width + 1
            delta += try_move!(r, Ost)
            if delta > width
                break
            end
            putmarker!(r)
        end
        move_until_border!(r, West)
        if isborder(r, Nord) 
            break
        end
        try_move!(r, Nord)
        width -= 1
    end
    move_until_border!(r, Sud)
    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
end

r = Robot("triangle.sit", animate=true)
triangle(r)