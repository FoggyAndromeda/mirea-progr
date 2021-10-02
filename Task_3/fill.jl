#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы

Обстановки:
fill.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, заполняющая поле маркерами и возвращающая робота в исходное положение
\n 
r - объект робота
"""
function fill!(r::Robot)
    first_corner_side = Nord
    second_corner_side = West
    path = move_to_corner!(r, first_corner_side, second_corner_side)
    direction = opposite_direction(second_corner_side)
    while !isborder(r, Sud)
        move_until_border!(r, direction, fill=true, first_fill=true)
        move_until_border!(r, opposite_direction(direction))
        move!(r, Sud)
    end
    move_until_border!(r, direction, fill=true, first_fill=true)
    move_to_corner!(r, first_corner_side, second_corner_side)
    move_path!(r, path, back=true)
end
