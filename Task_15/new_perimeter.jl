include("..\\types_and_structs.jl")

"""
Функция, расставляющая маркеры по внешней стенке и возвращающая робота в начальное положение
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function perimeter(robot::Robot)
    r = BorderRobot(robot)
    down = move_until_border!(r, Sud)
    left = move_until_border!(r, West)
    for direction in [Nord, Ost, Sud, West]
        move_until_border!(r, direction, fill = true)
        if !ismarker(r)
            putmarker!(r)
        end
    end
    do_n_steps_try!(r, Ost, left)
    do_n_steps_try!(r, Nord, down)
end
