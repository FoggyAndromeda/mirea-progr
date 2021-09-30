#= 
ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.

Обстановки:
cross_unmarked.sit - обстановка изначально без маркеров
cross_marked_1.sit - обстановка с маркерами, начальное положение робота не отмечено маркером изначально
cross_marked_2.sit - обстановка с маркерами, начальное положение робота отмечено маркером
=#
using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

function cross!(r::Robot)
    for direction in [Nord, West, Sud, Ost]
        steps = move_until_border!(r, direction, true)
        do_n_steps!(r, opposite_direction(direction), steps)
    end
    if !ismarker(r)
        putmarker!(r)
    end
end
