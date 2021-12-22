include("..\\types_and_structs.jl")

"""
Функция, рассставляющая маркеры в виде креста и возвращает робота в исходное положение (центр креста).
\n \n 
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function cross(robot::Robot)
    r = BorderRobot(robot)
    for i in 0:3
        steps = move_until_border!(r, HorizonSide(i), fill=true)
        do_n_steps_try!(r, opposite_direction(HorizonSide(i)), steps)
    end
    putmarker!(r)
end
