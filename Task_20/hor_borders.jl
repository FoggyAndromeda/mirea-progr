using HorizonSideRobots
include("..\\movement_patterns_lib.jl")

"""
Функция, считающая количество горизонтальных перегородок на поле (вертикальных - нет)
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function count_horizontal_borders(r::Robot)
    left = move_until_border!(r, West)
    down = move_until_border!(r, Sud)

    ans = 0
    while !isborder(r, Nord)
        mode = 0
        while !isborder(r, Ost)
            move!(r, Ost)
            if isborder(r, Nord) && mode == 0
                mode = 1
            elseif !isborder(r, Nord) && mode == 1
                ans += 1
                mode = 0
            end
        end
        move_until_border!(r, West)
        move!(r, Nord)
    end

    move_until_border!(r, Sud)
    do_n_steps!(r, Nord, down)
    do_n_steps!(r, Ost, left)
    return ans
end
