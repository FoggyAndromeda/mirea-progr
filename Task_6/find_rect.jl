#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. 
Робот - в произвольной клетке поля между внешней и внутренней перегородками. 
РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру внутренней перегородки поставлены маркеры.

Обстановки:
find_rect.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, находящая прямоугольник на поле, расставляющая маректы по переиметру найденного прямоугольника и возвращающая робота в исходное положение
\n 
r - объект робота
"""
function find_rect(r::Robot)
    path = move_to_corner!(r, Nord, West)
    width = move_until_border!(r, Ost)
    now_width = move_until_border!(r, West)
    while now_width == width
        move!(r, Sud)
        now_width = move_until_border!(r, Ost)
        move_until_border!(r, West)
    end
    move_until_border!(r, Ost)
    for direction in [Sud, Ost, Nord, West]
        follow_border(r, direction, orto_left(direction), true)
        move!(r, orto_left(direction))
    end
    move_to_corner!(r, Nord, West)
    move_path!(r, path, back=true)
end
