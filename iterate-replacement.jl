using Dates

open("combinedGeneModels.txt") do reference_file
    open("replace_file_input.txt", "r") do input_file
        open("replace_file_output.txt", "w") do output_file

            input_file_str = read(input_file, String)
            println("Loaded input file into memory.")

            all_lines = readlines(reference_file)
            all_lines_n = length(all_lines)

            println("Loaded reference file ($(all_lines_n)) into memory.")
            for (i, line) in enumerate(all_lines)

                scaffold_id, query_id, target_id, _, _, _, _ = split(line, "\t")
                
                # replace entire id first
                #println(query_id,"\t",target_id)
                input_file_str = replace(input_file_str, query_id => target_id)

                target_parent_id = split(target_id, ".")[1]
                if occursin("MAKER", query_id)
                    query_parent_id = split(query_id, ".")[1]
                elseif occursin("MSTRG", query_id)
                    query_parent_id = join(split(query_id, ".")[1:2], ".")
                end

                #println(query_parent_id,"\t",target_parent_id)
                
                # replace parent id next
                input_file_str = replace(input_file_str, query_parent_id => target_parent_id)
                now_var = Dates.format(now(), "HH:MM:SS")

                if ((i+1) % 5) == 0
                    println("[$(now_var)] [$(i+1)/$(all_lines_n)] $((i+1)/all_lines_n*100) %")
                end
            end
            write(output_file, input_file_str)
        end
    end
end
