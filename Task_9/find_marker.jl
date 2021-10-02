#=
ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. 
Робот - в произвольной клетке поля.

РЕЗУЛЬТАТ: Робот - в клетке с тем маркером.

Обстановки:
find_marker.sit
=#

using HorizonSideRobots

"""
Функция, делающая steps шагов в направлении direction или двигающаяся до маркера, расположенного не более, чем в steps шагов в направлении direction
\n 
///INPUT/// \n
r - объект робота\n 
direction - направление, в которое необходимо двигаться\n 
steps - количество шагов, которое необходимо сделать \n
///OUTPUT///\n
true, если функция нашла маркер на расстоянии не больше steps\n
false если робот сделал steps шагов в заданном направленнии и не нашел маркер\n
"""
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

"""
Функция, ищущая маркер на безграничном поле
\n 
r - объект робота
"""
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
