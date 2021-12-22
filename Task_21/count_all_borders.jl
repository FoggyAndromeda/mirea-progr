include("..\\types_and_structs.jl")

"""
Функция, считающая количество вертикальных и горизонатльных перегородок (прямоугольных - нет)
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function count_borders(robot::Robot)
    r = BorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)

    ans = 0
    directions = [Nord, Ost]
    for i in 1:2
        direction = directions[i]
        ort_direction = directions[i % 2 + 1]
        while !isborder(r, ort_direction)
            mode = 0
            while try_move!(r, direction) != 0
                if isborder(r, ort_direction) && mode == 0
                    mode = 1
                elseif !isborder(r, ort_direction) && mode == 1
                    ans += 1
                    mode = 0
                end
            end
            move_until_border!(r, opposite_direction(direction))
            move!(r, ort_direction)
        end
        move_until_border!(r, opposite_direction(ort_direction))
    end

    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
    return ans
end
