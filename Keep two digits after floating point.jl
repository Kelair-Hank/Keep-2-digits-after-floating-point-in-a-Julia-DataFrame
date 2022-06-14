using DataFrames, CSV, XLSX, Pipe

# The following file name may be renamed each time.
raw_df=@pipe XLSX.readtable("CCS算法对比temp.xlsx","Sheet1") |> DataFrames.DataFrame(_...)

m1=Matrix(raw_df)
DataFrames.recode!(m1,missing=>"missing")
raw_df=DataFrames.DataFrame(m1,DataFrames.names(raw_df))

function keep_two_digits(v::Vector)
    @simd for i=1:length(v)
        if typeof(v[i])==Float64
            v[i]=round(v[i],digits=2)
        end
    end
    return v
end

DataFrames.mapcols(keep_two_digits,raw_df)
m1=Matrix(raw_df)
DataFrames.recode!(m1,"missing"=>"")
raw_df=DataFrames.DataFrame(m1,DataFrames.names(raw_df))

# The following file name may be renamed each time.
XLSX.writetable("CCS算法对比temp.xlsx",raw_df,overwrite=true)
