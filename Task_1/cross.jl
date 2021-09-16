#= 
ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.

Обстановки:
cross_unmarked.sit - обстановка изначально без маркеров
cross_marked_1.sit - обстановка с маркерами, начальное положение робота не отмечено маркером изначально
cross_marked_2.sit - обстановка с маркерами, начальное положение робота отмечено маркером
=#
using HorizonSideRobots


opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)

function move_until_border!(r::Robot, direction::HorizonSide)::Int
    steps = 0
    while !isborder(r, direction)
        move!(r, direction)
        if !ismarker(r)
            putmarker!(r)
        end
        steps += 1
    end
    return steps
end

function move_back!(r::Robot, direction::HorizonSide, steps::Int)
    for _ in 1:steps
        move!(r, direction)
    end
end

function cross!(r::Robot)
    for direction in [Nord, West, Sud, Ost]
        steps = move_until_border!(r, direction)
        move_back!(r, opposite_direction(direction), steps)
    end
    if !ismarker(r)
        putmarker!(r)
    end
end
