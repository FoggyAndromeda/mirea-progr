#= 
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, 
на котором могут находиться также внутренние прямоугольные перегородки 
(все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)

РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры 

Обстановки:
corner.sit
=#

using HorizonSideRobots


opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)

function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int)
    for _ in 1:steps
        move!(r, direction)
    end
end

function find_corner(r::Robot, first_corner_side::HorizonSide, second_corner_side::HorizonSide)
    path = []
    directions = [first_corner_side, second_corner_side]
    while !isborder(r, first_corner_side) || !isborder(r, second_corner_side)
        for direction in directions
            steps = 0
            while !isborder(r, direction)
                steps += 1
                move!(r, direction)
            end
            push!(path, steps)
        end
    end
    putmarker!(r)
    for i in length(path):-1:1
        direction = opposite_direction(directions[(i + 1) % 2 + 1])
        do_n_steps!(r, direction, path[i])
    end
end

function find_corner_recursion(r::Robot, first_corner_side::HorizonSide, second_corner_side::HorizonSide)::Bool
    if !(isborder(r, first_corner_side) && isborder(r, second_corner_side))
        for direction in [first_corner_side, second_corner_side]
            if !isborder(r, direction)
                move!(r, direction)
                if find_corner_recursion(r, first_corner_side, second_corner_side)
                    move!(r, opposite_direction(direction))
                    return true
                end
                move!(r, opposite_direction(direction))
                return false
            end
        end
    else
        putmarker!(r)
        return true
    end
end

function markers_on_corners(r::Robot)
    for first in [Sud, Nord]
        for second in [Ost, West]
            find_corner_recursion(r, first, second)
        end
    end
end
