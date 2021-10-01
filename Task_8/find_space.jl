#=
ДАНО: Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, 
в которой имеется проход шириной в одну клетку.

РЕЗУЛЬТАТ: Робот - в клетке под проходом

Обстановки:
find_space.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

function find_space(r::Robot)
    steps = 1
    direction = Ost
    while isborder(r, Nord)
        do_n_steps!(r, direction, steps)
        steps += 1
        direction = opposite_direction(direction)
    end
end
