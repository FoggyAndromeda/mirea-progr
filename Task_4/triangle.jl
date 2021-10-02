#= 
ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, 
следующий - весь, за исключением одной последней клетки на Востоке, 
следующий - за исключением двух последних клеток на Востоке, и т.д.

Обстановки:
triangle.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, рекурсивно заполняющая строки снизу вверх уменьшающимся количеством маркеров. База рекурсии - сверху есть граница или количество маркеров уменьшилось до 0
\n 
r - объект робота
steps - количество маркеров, расставленных на данном шаге рекрусии, уменьшается каждую итерацию
"""
function recursion(r::Robot, steps::Int)
    do_n_steps!(r, Ost, steps, fill=true, first_fill=true)
    do_n_steps!(r, West, steps)
    if !isborder(r, Nord) && steps > 0
        move!(r, Nord)
        recursion(r, steps - 1)
    end
end

"""
Функция, заполняющая строчки поля снизу вверх уменьшающимся количеством маркеров и возвращает робота в исходное положение
\n 
r - объект робота
"""
function triangle!(r::Robot)
    first_corner_side = Sud
    second_corner_side = West
    path = move_to_corner!(r, first_corner_side, second_corner_side)
    width = move_until_border!(r, Ost)
    move_until_border!(r, West)
    recursion(r, width)
    move_to_corner!(r, first_corner_side, second_corner_side)
    move_path!(r, path, back=true)
end
