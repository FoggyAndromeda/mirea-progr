#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы

Обстановки:
fill.sit
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

function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int)
    for _ in 1:steps
        move!(r, direction)
    end
end

function fill_line!(r::Robot, direction::HorizonSide)
    putmarker!(r)
    while !isborder(r, direction)
        move!(r, direction)
        putmarker!(r)
    end
    direction = opposite_direction(direction)
    while !isborder(r, direction)
        move!(r, direction)
    end
end

function fill!(r::Robot)
    first_corner_side = Nord
    second_corner_side = West
    first, second = move_to_corner!(r, first_corner_side, second_corner_side)
    direction = opposite_direction(second_corner_side)
    while !isborder(r, Sud)
        fill_line!(r, direction)
        move!(r, Sud)
    end
    fill_line!(r, direction)
    move_to_corner!(r, first_corner_side, second_corner_side)
    do_n_steps!(r, opposite_direction(first_corner_side), first)
    do_n_steps!(r, opposite_direction(second_corner_side), second)
end



# Рекрусивный вариант
function recursive_fill!(r::Robot)
    putmarker!(r)
    for direction in [Nord, West, Sud, Ost]
        if !isborder(r, direction)
            move!(r, direction)
            if !ismarker(r)
                fill(r)
            end
            move!(r, change_direction(direction))
        end
    end
end