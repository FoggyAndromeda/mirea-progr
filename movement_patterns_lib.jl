using HorizonSideRobots

"""
Возвращает направление, противоположное данному
"""
opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)

"""
Напраление, перпендикулярное данному слева
"""
orto_left(d::HorizonSide) = HorizonSide((Int(d) + 1) % 4)
"""
Направление, перпендикулярное данному справа
"""
orto_right(d::HorizonSide) = HorizonSide((Int(d) + 3) % 4)

"""
Функция, перемещающая робота в угол со стенами в направлениях first_corner_side и second_corner_side
Возвращает путь, по которому робот попал в угол в формате вектора кортежей вида (направление, количество пройденных шагов)
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
"""
function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int, fill::Bool=false, first_fill::Bool=false)
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
"""
function move_path!(r::Robot, path::Vector, back::Bool=false)
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
"""
function move_until_border!(r::Robot, direction::HorizonSide, fill::Bool=false, first_fill::Bool=false)::Int
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
"""
function follow_border(r::Robot, direction::HorizonSide, border_direction::HorizonSide, fill::Bool=false)
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
"""
function move_diagonal!(r::Robot, first_direction::HorizonSide, second_direction::HorizonSide, fill::Bool=false, fill_first::Bool=false)
    if fill_first && !ismarker(r)
        putmarker!(r)
    end
    while !isborder(r, first_direction) && !isborder(r, second_direction)
        move!(r, first_direction)
        move!(r, second_direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
    end
end