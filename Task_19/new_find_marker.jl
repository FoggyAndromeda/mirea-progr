include("..\\types_and_structs.jl")

#TODO
"""
Функция, позволяющая сделать шаг через бесконечную перегородку.
"""
function try_move_inf_border!(r::BorderRobot, direction::HorizonSide)
    delta_r = 0
    delta_l = 0
    orto_direction = orto_left(direction)
    while isborder(r, direction)
        do_n_steps!(r, orto_direction, delta_r + delta_l)
        if orto_direction == orto_right(direction)
            delta_r += 1
        end
        if orto_direction == orto_left(direction)
            delta_l += 1
        end
        orto_direction = opposite_direction(orto_direction)
    end
    move!(r, direction)
    if orto_direction == orto_right(direction)
        do_n_steps!(r, orto_direction, delta_r)
    else
        do_n_steps!(r, orto_direction, delta_l)
    end
end

"""
Функция, делающая n шагов и останавливающаяся на маркере. 
"""
function do_n_steps_scan!(r::BorderRobot, direction::HorizonSide, steps::Int)
    for i in 1:steps
        try_move_inf_border!(r, direction)
        if ismarker(r)
            return true
        end
    end
    return false
end

"""
Функция, ищущая маркер на бесконечном поле
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function find_marker(robot::Robot)
    r = BorderRobot(robot)
    direction = Nord
    now_steps = 1
    flag = false
    while !do_n_steps_scan!(r, direction, now_steps)
        direction = orto_right(direction)
        if flag
            now_steps += 1
        end
        flag = !flag
    end
end
