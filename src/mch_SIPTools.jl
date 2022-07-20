#by Eric Torkia, 2019-2022 (Please join the team so I don't have to do this alone)

using DataFrames, CSV, Distributions

# Test Data
    # source_data = rand(Normal(), 1000, 5)
    # FileName = "sip_export"

"""
    dfnames(headings)

Adds ":" in front of all items in an array. This format is required by the DataFrame packages when giving names to columns.
"""
function dfnames(headings)
h_list = []
    for i = 1:size([headings...],1)
        name = ":" * headings[i]
        println(name)
        push!(h_list, name)

    end
    return h_list
end

"""
    sip2csv(FileName, source_df, s_name="SLURP", s_origin="Julia Language")

- In order to export a SIP Library from Julia, you simply need to have a DataFrame.
- Only specify header fields if your data does not contain any.
- Also make to specify the full filename, including extension
"""
function sip2csv(FileName, source_df, s_name="SLURP", s_origin="Julia Language")

    csvfilename = "$FileName.csv"
    csvfile = open(csvfilename, "w") #Create CSV csvfile
    numSamples = size(source_df, 1)
    colCount = size(source_df, 2)
    df_names = SIPNames(source_df)

    #colwise methods
    meta_mean = lineprep([[mean(col) for col = eachcol(source_df)]])
    meta_median = lineprep([[median(col) for col = eachcol(source_df)]])
    meta_min = lineprep([[minimum(col) for col = eachcol(source_df)]])
    meta_max = lineprep([[maximum(col) for col = eachcol(source_df)]])

    #Load MetaData Table
    metafilename = "$s_name"*"_meta.csv"

    if isfile(metafilename) == true
        meta_df = CSV.read(metafilename, datarow=4)
        AttributeCount = size(meta_df, 1)
        SipAttrsEnd = 23 + AttributeCount
        SipTlc = SipAttrsEnd + 4


        #metadata = convert(Matrix, meta_df)
        # Setup SIP Header
        write(csvfile,"CSV,,,,,,Always have something in A1,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        Control,,SheetName,N/A,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,FilePath,$FileName.csv,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,SlurpAttrs,C14:C16,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,SipAttrs,C19:C$SipAttrsEnd,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,SipTlc,A$SipTlc,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,ClearFirst,TRUE,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,numSamples,$numSamples,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        SLURP,,name,$s_name,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,count,$colCount,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,origin,$s_origin,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        SIP,,name,$df_names
        ,,mean,$meta_mean
        ,,median,$meta_median
        ,,min,$meta_min
        ,,max,$meta_max,\n")
        close(csvfile)

        CSV.write("$FileName.csv", meta_df, append=true)
        csvfile = open(csvfilename, "a")
        write(csvfile,",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n")

        close(csvfile)

        CSV.write("$FileName.csv", source_df, append=true, writeheader=true)

    elseif isfile(metafilename) == false

        # Setup SIP Header
        write(csvfile,"CSV,,,,,,Always have something in A1,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        Control,,SheetName,N/A,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,FilePath,$FileName.csv,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,SlurpAttrs,C14:C16,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,SipAttrs,C19:C23,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,SipTlc,A27,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,ClearFirst,TRUE,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,numSamples,$numSamples,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        SLURP,,name,$s_name,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,count,$colCount,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,origin,$s_origin,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        SIP,,name,$df_names
        ,,mean,$meta_mean
        ,,median,$meta_median
        ,,min,$meta_min
        ,,max,$meta_max
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n")
        close(csvfile)
        CSV.write("$FileName.csv", source_df, append=true, writeheader=true)
    end


end


"""
    SIPNames(source_df)

Preps a vector of names for the CSV export of SIPs by removing unnecessary characters in front of all items in an array.
"""
function SIPNames(source_df)
    df_names=names(source_df)
    df_names=string([df_names])
    df_names = replace(df_names, "Array{Symbol,1}[[:" =>"")
    df_names = replace(df_names, "]]" =>"")
    df_names = replace(df_names, ":" =>"")
    return df_names
end
"""
    lineprep(line_array)

When you want to strip "[]" from Arrays for export to CSV

"""
function lineprep(line_array)
    val = string([line_array])
    val = replace(val, "Array{Array{Float64,1},1}" =>"")
    val = replace(val, "[" =>"")
    val = replace(val, "]" =>"")
    return val
end

#Loading a SIPloadsip
"""
    importxlsip(FileName, source="")

This function allows to import SIPs in CSV format from Excel using the SIP 2.0 Standard (Stochastic Information Packets, Savage[2009]) to build unified simulation models.
Based on the CSV package, the function cleans up meta data and cleans out redundant columns. You can also set a *source string* that will be included in your SIP DataFrame as a dimension.
"""
function importxlsip(FileName, source="")
println("Processing SIP Data...\n")
    open(FileName) do file
        linecounter = 1
            for ln in eachline(file)
                if occursin("SIP,,name,", ln) == true
                    println("header_row: $linecounter")
                    global header_row = linecounter
                    linecounter +=1
                elseif occursin("SIPs,,,", ln) == true
                    println("data_row: $linecounter")
                    global start_row = linecounter
                else linecounter +=1
                end
            end
    end
    println("")
    println("SIPs are acceccisble via Dataframe. \n")
    println("header=$header_row, datarow=$start_row")
    SLURP = CSV.read(FileName, header=header_row, datarow=start_row)
    select!(SLURP, Not([:SIP, :Column2, :name])) #replaces deletecols!
    #SLURP[!, :source] .= source # new syntax. now uses .functions to broadcast
    println("")
    print(describe(SLURP))
    println("\n")
    return SLURP
end

"""
    importsip(FileName, source="Not specified by user")

This function allows to import SIPs in CSV format from Julia using the SIP 2.0 Standard (Stochastic Information Packets, Savage[2009]) to build unified simulation models.
Based on the CSV package, the function cleans up meta data and cleans out redundant columns. You can also set a *source string* that will be included in your SIP DataFrame as a dimension.
"""
function importsip(FileName, source="Not specified by user")
    open(FileName) do file
        global linecounter = 1
            for ln in eachline(file)
            linecounter +=1
            end

            if linecounter < 1000
                rounding_digit = -2
            else rounding_digit = -3
            end

        Trial_Count = round(linecounter, digits=rounding_digit)
        global start_row = Int64(linecounter - Trial_Count)
        global header_row = start_row-1
        end
    println("Header Row: $header_row and Data_Row: $start_row")
    SLURP = CSV.read(FileName, header=header_row, datarow=start_row)
    #SLURP[!, :source] .= source # new syntax. now uses .functions to broadcast
    println("")
    print(describe(SLURP))
    println("\n")
return SLURP
end

"""
    genmeta(source_df, s_name="SLURPName")

SIPs using the SIP 2.0 Standard (Stochastic Information Packets, Savage[2009]) require that Meta Data be available and maintained. This function creates a file template to add MetaData to your SIP Library. This is a seperate file must accompany the DataFrame to generate the SIP Library correctly. If ommited, the file will export the SIP Library without any metadata.
"""
function genmeta(source_df, s_name="SLURPName")
    #File Operations
    csvfilename = string("$s_name","_meta.csv")
    #csvfilename = "$FileName.csv"
    csvfile = open(csvfilename, "w") #Create CSV csvfile
    ColHeadings = SIPNames(source_df)

    #CSV Body
    write(csvfile,"This file is used to store SIP level MetaData and dimensions for SIP Library : $s_name,,
    ,,,
    ,,SIP Attribute, $ColHeadings,,
    ,,,\n")

#Close File
    close(csvfile)
    CSV.write("$csvfilename.csv")
end
