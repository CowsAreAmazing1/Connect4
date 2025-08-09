
struct GameNode
    board::Board
    result::Result
    turn::Symbol
    children::Vector{GameNode}

    function GameNode(board::Board, turn::Symbol)
        new_result = result(board)
        new(board, new_result, turn, Vector{GameNode}())
    end

    function Base.show(io::IO, gn::GameNode)
        out = "\n"
        out *= string(gn.board)
        out *= "\n$(gn.turn)s turn"
        out *= "\nGoes to $(length(gn.children))"
        println(io, out)
    end
end

result(game::GameNode) = result(game.board)

function allMoves(game::GameNode)
    games = GameNode[]
    turn = game.turn == :red ? :yellow : :red
    for col in 1:7
        temp_board = copy(game.board)
        try
            playerMove!(temp_board, turn, col)
            temp_game = GameNode(temp_board, turn)
            push!(games, temp_game)
        catch
            continue
        end
    end
    return games
end

allMoves!(game::GameNode) = append!(game.children, allMoves(game))