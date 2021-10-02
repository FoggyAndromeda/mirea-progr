#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок)

РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, 
и все остальные клетки поля промаркированы в шахматном порядке

Обстановки:
chess.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, расставляющая маркеры на поле в шахматном порядке (начальное положение робота закрашено) и возвращает робота в исходное положение
\n 
r - объект робота
"""
function chess(r::Robot)
    y = move_until_border!(r, Nord)
    x = move_until_border!(r, West)
    now_x = 0
    now_y = 0
    while !isborder(r, Sud)
        while !isborder(r, Ost)
            if (now_x + now_y) % 2 == (x + y) % 2
                putmarker!(r)
            end
            move!(r, Ost)
            now_x += 1
        end
        if (now_x + now_y) % 2 == (x + y) % 2
            putmarker!(r)
        end
        move_until_border!(r, West)
        move!(r, Sud)
        now_y += 1
    end
    while !isborder(r, Ost)
        if (now_x + now_y) % 2 == (x + y) % 2
            putmarker!(r)
        end
        move!(r, Ost)
        now_x += 1
    end
    if (now_x + now_y) % 2 == (x + y) % 2
        putmarker!(r)
    end
    move_to_corner!(r, Nord, West)
    do_n_steps!(r, Sud, y)
    do_n_steps!(r, Ost, x)
end
