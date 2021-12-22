include("..\\types_and_structs.jl")

"""
Функция, заполняющая поле меркерами и возвращающая робота в начальное положение
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function fill(robot::Robot)
    r = BorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)
    fill_rec(get(r))
    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
end

"""
Рекурсивное заполнение поля. Начальное положение - левый нижний угол.
"""
function fill_rec(r::Robot)
    putmarker!(r)
    for direction in [Nord, Ost]
        if !isborder(r, direction)
            move!(r, direction)
            if !ismarker(r)
                fill_rec(r)
            end
            move!(r, opposite_direction(direction))
        end
    end
end
