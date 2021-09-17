#= 
ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, 
следующий - весь, за исключением одной последней клетки на Востоке, 
следующий - за исключением двух последних клеток на Востоке, и т.д.

Обстановки:
triangle.sit
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

function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int, mark::Bool=false)
    if mark
        putmarker!(r)
    end
    for _ in 1:steps
        move!(r, direction)
        if mark
            putmarker!(r)
        end
    end
end

function count_width(r::Robot)::Int
    counter = 0
    while !isborder(r, Ost)
        counter += 1
        move!(r, Ost)
    end
    while !isborder(r, West)
        move!(r, West)
    end
    return counter
end

function recursion(r::Robot, steps::Int)
    do_n_steps!(r, Ost, steps, true)
    do_n_steps!(r, West, steps)
    if !isborder(r, Nord) && steps > 0
        move!(r, Nord)
        recursion(r, steps - 1)
    end
end

function triangle!(r::Robot)
    first_corner_side = Sud
    second_corner_side = West
    first, second = move_to_corner!(r, first_corner_side, second_corner_side)
    width = count_width(r)
    recursion(r, width)
    move_to_corner!(r, first_corner_side, second_corner_side)
    do_n_steps!(r, opposite_direction(first_corner_side), first)
    do_n_steps!(r, opposite_direction(second_corner_side), second)
end
