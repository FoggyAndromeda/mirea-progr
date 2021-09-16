#=
ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок и маркеров)
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы

Обстановки:
perimeter.sit
=#

using HorizonSideRobots


opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)

function move_to_corner!(r::Robot, first_corner_side::HorizonSide, second_corner_side::HorizonSide)
    first = 0
    second = 0
    while !isborder(r, first_corner_side)
        move!(r, first_corner_side)
        first += 1
    end
    while !isborder(r, second_corner_side)
        move!(r, second_corner_side)
        second += 1
    end
    return first, second
end

function move_until_border!(r::Robot, direction::HorizonSide)
    while !isborder(r, direction)
        move!(r, direction)
        putmarker!(r)
    end
end

function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int)
    for _ in 1:steps
        move!(r, direction)
    end
end

function perimeter!(r::Robot)
    first_corner_side = Sud
    second_corner_side = Ost
    steps1, steps2 = move_to_corner!(r, first_corner_side, second_corner_side)
    for i in 0:3
        move_until_border!(r, HorizonSide(i))
    end
    do_n_steps!(r, opposite_direction(first_corner_side), steps1)
    do_n_steps!(r, opposite_direction(second_corner_side), steps2)
end
