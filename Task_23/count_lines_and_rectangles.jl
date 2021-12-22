#TODO: solve
#=
Заполнить двумерный массив аналогично задаче 22 -> запустить обход в глубину, получить кол-во компонент связности ->
-> Вернуть робота в левы нижний, начать обходить перегородки:
---- Если в направлении Ost есть перегородка, то проверить элемент map[x + 1][y]
---- Если элемент == -1, то это перегородка, иначе это прямоугольник
Аналогично обходим горизонтальные перегородки 
=#

include("..\\movement_patterns_lib.jl")
include("..\\types_and_structs.jl")

"""
Функция, считающая количество отрезков и прямоугольников. Возвращает кортеж (прямоугольники, отрезков)
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function count_lines_and_rectangles(robot::Robot)
    data = create_map!(robot)
    rectangles = maximum(map(max, data))
    lines = 0
    r = CoordBorderRobot(robot)
    left = move_until_border!(r, West)
    down = move_until_border!(r, Sud)
    set_coords(r.coord, 1, 1)
    while !isborder(r, Nord)
        state = false
        while try_move!(r, Ost) != 0
            if isborder(r, Nord)
                x, y = get_coords(r)
                if (data[x, y + 1] == -1)
                    if !state
                        state = true
                    end
                elseif state
                    state = false
                    lines += 1
                end
            elseif state
                state = false
                lines += 1
            end
        end
        move_until_border!(r, West)
        try_move!(r, Nord)
    end
    println("Vertical:\t", lines)
    move_until_border!(r, Sud)
    while !isborder(r, Ost)
        state = false
        while try_move!(r, Nord) != 0
            if isborder(r, Ost)
                x, y = get_coords(r)
                if (data[x + 1, y] == -1)
                    if !state
                        state = true
                    end
                elseif state
                    state = false
                    lines += 1
                end
            elseif state
                state = false
                lines += 1
            end
        end
        move_until_border!(r, Sud)
        try_move!(r, Ost)
    end
    move_until_border!(r, Sud)
    do_n_steps_try!(r, Nord, down)
    do_n_steps_try!(r, Ost, left)
    return rectangles, lines
end
