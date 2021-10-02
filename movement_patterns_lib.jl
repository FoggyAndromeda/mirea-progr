using HorizonSideRobots

"""
Возвращает направление, противоположное данному
\n
\nd - данное направление
"""
opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)

"""
Напраление, перпендикулярное данному слева
\n
\nd - данное направление
"""
orto_left(d::HorizonSide) = HorizonSide((Int(d) + 1) % 4)

"""
Направление, перпендикулярное данному справа
\n
\nd - данное направление
"""
orto_right(d::HorizonSide) = HorizonSide((Int(d) + 3) % 4)

"""
Функция, перемещающая робота в угол со стенами в направлениях first_corner_side и second_corner_side
Возвращает путь, по которому робот попал в угол в формате вектора кортежей вида (направление, количество пройденных шагов)
\n
\n///INPUT///
\nr - объект робота
\nfirst_corner_side - первое направление, в которую нужно двигаться
\nsecond_corner_side - второе направление, в которое нужно двигаться
\n
\n///OUTPUT///
\npath - путь, пройденный роботом до угла в формате [(*направление*, *количество шагов*), ...]
"""
function move_to_corner!(r::Robot, first_corner_side::HorizonSide, second_corner_side::HorizonSide)
    path = []
    while !isborder(r, first_corner_side) || !isborder(r, second_corner_side)
        push!(path, (first_corner_side, move_until_border!(r, first_corner_side)))
        push!(path, (second_corner_side, move_until_border!(r, second_corner_side)))
    end
    return path
end

"""
Перемещает робота на steps шагов в направлении direction. Параметр fill указывает, закрашивать ли клетки, по которым идет робот.
\n
\nr - объект робота
\ndirection - направление, в которое будет двигаться робот
\nsteps - количество шагов, которое нужно сделать роботу
\n=== kwargs ===
\nfill - нужно ли проставлять маркеры по пути следования (по умолчанию false)
\nfirst_fill - нужно ли ставить маркер в первой клетке по пути следования робота (по умолчанию false)
"""
function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int; fill::Bool=false, first_fill::Bool=false)
    if fill && !ismarker(r) && first_fill
        putmarker!(r)
    end
    for _ in 1:steps
        move!(r, direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
    end
end

"""
Перемещает робота по пути path. Параметр back указывает, в какую сторону надо пройти по пути: по нему или в обратную сторону
\n
\nr - объект робота
\npath - путь, который нужно пройти роботу в формате [(*направление*, *количество шагов*), ...]
\n=== kwargs ===
\nback - в какую сторону необходимо двигаться: по направлению path или в противоположную (по умолчанию false)
"""
function move_path!(r::Robot, path::Vector; back::Bool=false)
    if back
        reverse!(path)
    end
    for elem in path
        direction, steps = elem
        if back
            direction = opposite_direction(direction)
        end
        do_n_steps!(r, direction, steps)
    end
end

"""
Двигает робота до стенки в заданном направлении. Параметр fill указывает, закрашивать ли клетки, по которым идет робот.
Возвращает количество шагов до стены
\n
\n///INPUT///
\nr - объект робота
\ndirection - направление, в котором роботу необходимо двигаться
\n=== kwargs ===
\nfill - нужно ли проставлять маркеры по пути следования (по умолчанию false)
\nfirst_fill - нужно ли поставить маркер в начальной клетке (по умолчанию false)
\n
\n///OUTPUT///
\nsteps - количество шагов от начального положения до стенки
"""
function move_until_border!(r::Robot, direction::HorizonSide; fill::Bool=false, first_fill::Bool=false)::Int
    steps = 0
    if fill && !ismarker(r) && first_fill
        putmarker!(r)
    end
    while !isborder(r, direction)
        move!(r, direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
        steps += 1
    end
    return steps
end

"""
Двигает робота в направлении direction до тех пор, пока со стороны border_direction есть стенка
\n
\nr - объект робота
\ndirection - направление, в котором необходимо двигаться
\nborder_direction - с какой стороны должна быть стенка, по которой надо идти
\n=== kwargs ===
\nfill - нужно ли проставлять маркеры во время движения (по умолчанию false)
"""
function follow_border!(r::Robot, direction::HorizonSide, border_direction::HorizonSide, fill::Bool=false)
    if fill && !ismarker(r)
        putmarker!(r)
    end
    while isborder(r, border_direction)
        move!(r, direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
    end
end

"""
Двигает робота по диагонали в направлении first_direction, second_direction. Параметр fill указывает, закрашивать ли клетки, по которым идет робот.
\n
\n///INPUT///
\nr - объект робота
\nfirst_direction - первое направление, задающее диагональ
\nsecond_direction - второе направление, задающее диагональ
\n=== kwargs ===
\nfill - нужно ли проставлять маркеры по пути следования (по умолчанию false)
\nfirst_fill - нужно ли поставить маркер в начальной клетке (по умолчанию false)
\n
\n///OUTPUT///
\nsteps - количество шагов по диагонали до стенки
"""
function move_diagonal!(r::Robot, first_direction::HorizonSide, second_direction::HorizonSide; fill::Bool=false, fill_first::Bool=false)::Int
    if fill_first && !ismarker(r)
        putmarker!(r)
    end
    steps = 0
    while !isborder(r, first_direction) && !isborder(r, second_direction)
        move!(r, first_direction)
        move!(r, second_direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
        steps += 1
    end
    return steps
end

"""
Перемещает робота на steps шагов по диагонали
\n
\nr - объект робота
\nfirst_direction - первое направление, задающее диагональ
\nsecond_direction - второе направление, задающее диагональ
\nsteps - количество шагов, которе робот должен сделать по диагонали
"""
function do_n_diagonal!(r::Robot, first_direction::HorizonSide, second_direction::HorizonSide, steps::Int)
    for i in 1:steps
        move!(r, first_direction)
        move!(r, second_direction)
    end
end

"""
Функция, перемещающая робота на один шаг в заданном направлении. Если там есть перегородка, робот пытается ее обойти.
\n
\n///INPUT///
\nr - объект робота
\ndirection - направление, в котором нужно сделать шаг
\n
\n///OUTPUT///
\ntrue, если стенки нет или стенку можно обойти
\nfalse, если стенку нельзя обойти (робот находится у границы)
"""
function move_through_wall!(r::Robot, direction::HorizonSide)::Bool
    normal_direction = orto_left(direction)
    delta_x = 0
    while isborder(r, direction)
        if isborder(r, normal_direction)
            do_n_steps!(r, opposite_direction(normal_direction), delta_x)
            return false
        end
        move!(r, normal_direction)
        delta_x += 1
    end
    move!(r, direction)
    normal_direction = opposite_direction(normal_direction)
    while isborder(r, normal_direction)
        move!(r, direction)
    end
    do_n_steps!(r, normal_direction, delta_x)
    return true
end