import HorizonSideRobots: move!, putmarker!, isborder, ismarker, HorizonSide, temperature, Nord, Sud, Ost, West, Robot

#TODO: comments
opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)
orto_left(d::HorizonSide) = HorizonSide((Int(d) + 1) % 4)
orto_right(d::HorizonSide) = HorizonSide((Int(d) + 3) % 4)
#-----------------------------------------------
abstract type AbstractRobot
end

move!(robot::AbstractRobot, side::HorizonSide) = move!(get(robot), side)
isborder(robot::AbstractRobot,  side::HorizonSide) = isborder(get(robot), side)
putmarker!(robot::AbstractRobot) = putmarker!(get(robot))
ismarker(robot::AbstractRobot) = ismarker(get(robot))
temperature(robot::AbstractRobot) = temperature(get(robot))
get(robot::AbstractRobot) = nothing


function do_n_steps!(r::AbstractRobot, direction::HorizonSide, steps::Int; fill::Bool=false, first_fill::Bool=false)
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

function move_until_border!(r::AbstractRobot, direction::HorizonSide)
    counter = 0
    while !isborder(r, direction)
        move!(r, direction)
        counter += 1
    end
    return counter
end

function do_n_steps(r::AbstractRobot, dir::HorizonSide, n::Integer)
    for i in 1:n
        putmarker!(r)
        move!(r, dir)
    end
end
#------------------------------------------------
abstract type AbstractBorderRobot <: AbstractRobot
end

function try_move!(r::AbstractBorderRobot, direction::HorizonSide)
    normal_direction = orto_left(direction)
    delta_x = 0
    while isborder(r, direction)
        if isborder(r, normal_direction)
            do_n_steps!(r, opposite_direction(normal_direction), delta_x)
            return 0
        end
        move!(r, normal_direction)
        delta_x += 1
    end
    move!(r, direction)
    delta_dir = 1;
    normal_direction = opposite_direction(normal_direction)
    while isborder(r, normal_direction) && delta_x != 0
        move!(r, direction)
        delta_dir += 1
    end
    do_n_steps!(r, normal_direction, delta_x)
    return delta_dir
end

function move_until_border!(r::AbstractBorderRobot, direction::HorizonSide; fill::Bool=false)
    counter = 0
    while try_move!(r, direction) != 0
        if fill
            putmarker!(r)
        end
        counter += 1
    end
    return counter
end

function do_n_steps_try!(r::AbstractBorderRobot, dir::HorizonSide, n::Integer, fill::Bool=false)
    for i in 1:n
        if fill
            putmarker!(r)
        end
        try_move!(r, dir)
    end
end

mutable struct BorderRobot <: AbstractBorderRobot
    robot::Robot
    BorderRobot(r::Robot) = new(r)
    BorderRobot() = new(HorizonSideRobots.Robot())
end

get(robot::BorderRobot) = robot.robot

#--------------------------------------------------
mutable struct Coords
    x::Integer
    y::Integer
    Coords() = new(0, 0)
    Coords(a::Integer, b::Integer) = new(a, b)
end

function move!(c::Coords, direction::HorizonSide)
    if direction == Nord
        c.y += 1
    elseif direction == Sud
        c.y -= 1
    elseif direction == Ost
        c.x += 1
    else
        c.x -= 1
    end
end

get_coords(c::Coords) = [c.x, c.y]

function set_coords(c::Coords, x::Int, y::Int)
    c.x = x
    c.y = y
end
struct CoordBorderRobot <:AbstractBorderRobot
    robot::Robot
    coord::Coords
    CoordBorderRobot(r::Robot, c::Coords) = new(r, c)
    CoordBorderRobot(r::Robot) = new(r, Coords())
    CoordBorderRobot() = new(Robot(), Coords())
end

function move!(r::CoordBorderRobot, direction::HorizonSide)
    move!(r.robot, direction)
    move!(r.coord, direction)
end

get(r::CoordBorderRobot) = r.robot
abstract type AbstractCoordRobot <: AbstractRobot
end

function get_coords(r::AbstractCoordRobot)
    return r.coords.x, r.coords.y
end

function move!(robot::AbstractCoordRobot, direction::HorizonSide)
    move!(robot.robot, direction)
    move!(robot.coords, direction)
end

mutable struct CoordRobot <: AbstractCoordRobot
    robot::Robot
    coords::Coords
    CoordRobot(r::Robot, x::Integer, y::Integer) = new(r, Coords(x, y))
    CoordRobot(r::Robot) = new(r, Coords())
    CoordRobot() = new(Robot(), Coords())
end

get(r::CoordRobot) = r.robot
