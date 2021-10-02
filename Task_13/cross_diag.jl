#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольной рамкой поля без внутренних перегородок и маркеров.

РЕЗУЛЬТАТ: Робот - в исходном положении в центре косого креста (в форме X) из маркеров.

Обстановки:
cross.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, создающая крест из маркеров (в форме Х) с центром в начальном положении робота
\n 
r - объект робота
"""
function diag_cross(r::Robot)
    for first in [Nord, Sud]
        for second in [West, Ost]
            steps = move_diagonal!(r, first, second, fill=true)
            do_n_diagonal!(r, opposite_direction(first), opposite_direction(second), steps)
        end
    end
    putmarker!(r)
end
