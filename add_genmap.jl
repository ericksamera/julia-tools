using ArgParse
using DelimitedFiles

function get_genmap_score(chr::String, pos::Int)
    """
    Wrapper for sed to get a specific line in chromosome.txt which contains genmap score.
    """
    cmd = `sed -n -e $(string(pos) * "{p;q;}") $(joinpath("genmap", chr * ".txt"))`
    result = read(cmd, String)
    return parse(Float64, strip(result))
end

function add_annotations(input_file::String, output_file::String)
    """
    Wrapper for adding annotations while streamling through zcat.
    """
    result = read(`zcat $(input_file)`, String)
    open(output_file, "w") do output
        for line in split(result, '\n')
            if startswith(line, '#')
                if startswith(line, "#CHR")
                    HEADER_INFO = "##INFO=<ID=GENMAP,Number=1,Type=Float,Description=\"Genome Mappability Score\">"
                    write(output, HEADER_INFO * "\n")
                end
                write(output, line * "\n")
            else
                line_items = split(strip(line), '\t')
                if length(line_items) >= 8
                    CHROM, POS = String(line_items[1]), parse(Int, line_items[2])
                    genmap_score = get_genmap_score(CHROM, POS)
                    line_items[8] *= ";GENMAP=$genmap_score"
                    write(output, join(line_items, '\t') * "\n")
                end
            end
        end
    end
end

function main()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "-i", "--input"
            help = "input file path"
            required = true
            arg_type = String
        "-o", "--output"
            help = "output file path"
            required = true
            arg_type = String
    end
    args = parse_args(s)
    add_annotations(args["input"], args["output"])
end

isinteractive() || main()
