open("combinedGeneModels.txt", "r") do reference_file
    open("output-file.txt", "w") do output_file
        for reference_line in eachline(reference_file)
            reference_scaffold_id, query_id, reference_id, query_start, query_end, reference_start, reference_end = split(reference_line, "\t")

            if occursin("MSTRG", query_id)
                parent_id = join(split(String(query_id), ".")[1:2], ".")
                target_file = "transcripts.fasta.transdecoder.genomeCentric.gff3"

            elseif occursin("MAKER", query_id)
                parent_id = split(String(query_id), ".")[1]
                target_file = "makerGenes.gff3"
            end

            open(target_file) do query_gff3_file
                for gene_line in eachline(query_gff3_file)
                    if occursin(String(parent_id), String(gene_line))
                        Base.write(output_file, *(gene_line, "\n"))
                    else
                        continue
                    end
                end
            end
        end
    end
end
