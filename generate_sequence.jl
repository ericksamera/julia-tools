"""

"""

using ArgParse
using StatsBase

function parse_commandline()
    args = ArgParseSettings()

    @add_arg_table args begin
        "--gc"
            arg_type = Int
            default = 50'
            help = "integer gc percentage (55% = 55)"
        "--length"
            arg_type = Int
            default = 200
            help = "length of sequence"
        "--benchmark"
            action = :store_true
            help = "skip print-out, benchmark computation time"
    end

    return parse_args(args)
end

function generate_seq(gc_content, seq_length)
    """
    """
    nucleotides = ["A", "T", "C", "G"]
    weights = [((100-gc_content)/2)/100, ((100-gc_content)/2)/100, (gc_content/2)/100, (gc_content/2)/100,]
    return join(sample(nucleotides, Weights(weights), seq_length))
end
function main()
    parsed_args = parse_commandline()
    
    generated_sequence = generate_seq(parsed_args["gc"], parsed_args["length"])
    if !parsed_args["benchmark"]
        println(join(my_samps))
    end
end

main()
