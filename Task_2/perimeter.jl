#=
ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок и маркеров)
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы

Обстановки:
perimeter.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, расставляющая маркеры по внешней стенке и возвращающая робота в исходное положение
\n
r - объект робота
"""
function perimeter!(r::Robot)
    first_corner_side = Sud
    second_corner_side = Ost
    path = move_to_corner!(r, first_corner_side, second_corner_side)
    for i in 0:3
        move_until_border!(r, HorizonSide(i), fill=true)
    end
    move_path!(r, path, back=true)
end
