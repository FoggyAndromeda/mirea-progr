#=
ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. 
Робот - в произвольной клетке поля.

РЕЗУЛЬТАТ: Робот - в клетке с тем маркером.

Обстановки:
find_marker.sit
=#

using HorizonSideRobots

function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int)
    for i in 1:steps
        move!(r, direction)
        if ismarker(r)
            return true
        end
    end
    if ismarker(r)
        return true
    end
    return false
end

function find_marker!(r::Robot)
    if ismarker(r)
        return true
    end
    steps = 0
    now_step = 1
    direction = Nord
    while !do_n_steps!(r, direction, now_step)
        direction = HorizonSide((Int(direction) + 1) % 4)
        steps += 1
        if steps % 2 == 0
            now_step += 1
        end
    end
end

r = Robot("find_marker.sit", animate=true)
find_marker!(r)
