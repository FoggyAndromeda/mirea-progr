#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, 
на котором могут находиться также внутренние прямоугольные перегородки 
(все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)

РЕЗУЛЬТАТ: Робот - в исходном положении, и в 4-х приграничных клетках, две из которых имеют ту же широту, 
а две - ту же долготу, что и Робот, стоят маркеры.

Обстановки:
projection.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

function projections!(r::Robot)
    for directions in [(Nord, West), (Sud, Ost)]
        first, second = directions
        path = move_to_corner!(r, first, second)
        steps_from_origin = [sum(path[i][2] for i in j:2:length(path)) for j in 1:2]
        for i in 1:2
            do_n_steps!(r, opposite_direction(directions[i]), steps_from_origin[i])
            putmarker!(r)
            do_n_steps!(r, directions[i], steps_from_origin[i])
        end
        move_path!(r, path, true)
    end
end
