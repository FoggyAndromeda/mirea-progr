#= 
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, 
на котором могут находиться также внутренние прямоугольные перегородки 
(все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)

РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры 

Обстановки:
corner.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

function markers_on_corners(r::Robot)
    for first in [Sud, Nord]
        for second in [Ost, West]
            path = move_to_corner!(r, first, second)
            putmarker!(r)
            move_path!(r, path, true)
        end
    end
end
