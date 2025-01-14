@testset "TableDataset" begin
    @testset "TableDataset from rowaccess table" begin
        Tables.columnaccess(::Type{<:Tables.MatrixTable}) = false
        Tables.rowaccess(::Type{<:Tables.MatrixTable}) = true

        testtable = Tables.table([1 4.0 "7"; 2 5.0 "8"; 3 6.0 "9"])
        td = TableDataset(testtable)

        @test collect(@inferred(getobs(td, 1))) == [1, 4.0, "7"]
        @test numobs(td) == 3
    end

    @testset "TableDataset from columnaccess table" begin
        Tables.columnaccess(::Type{<:Tables.MatrixTable}) = true
        Tables.rowaccess(::Type{<:Tables.MatrixTable}) = false

        testtable = Tables.table([1 4.0 "7"; 2 5.0 "8"; 3 6.0 "9"])
        td = TableDataset(testtable)

        @test collect(@inferred(NamedTuple, getobs(td, 2))) == [2, 5.0, "8"]
        @test numobs(td) == 3

        @test getobs(td, 1) isa NamedTuple
    end

    @testset "TableDataset from DataFrames" begin
        testtable = DataFrame(
            col1 = [1, 2, 3, 4, 5],
            col2 = ["a", "b", "c", "d", "e"],
            col3 = [10, 20, 30, 40, 50],
            col4 = ["A", "B", "C", "D", "E"],
            col5 = [100.0, 200.0, 300.0, 400.0, 500.0],
            split = ["train", "train", "train", "valid", "valid"],
        )
        td = TableDataset(testtable)
        @test td isa TableDataset{<:DataFrame}

        @test collect(@inferred(getobs(td, 1))) == [1, "a", 10, "A", 100.0, "train"]
        @test numobs(td) == 5
    end

    @testset "TableDataset from CSV" begin
        open("test.csv", "w") do io
            write(io, "col1,col2,col3,col4,col5, split\n1,a,10,A,100.,train")
        end
        testtable = CSV.File("test.csv")
        td = TableDataset(testtable)
        @test td isa TableDataset{<:CSV.File}
        @test collect(@inferred(getobs(td, 1))) == [1, "a", 10, "A", 100.0, "train"]
        @test numobs(td) == 1
        rm("test.csv")
    end

    @testset "TableDataset is a table" begin
        testtable = DataFrame(
            col1 = [1, 2, 3, 4, 5],
            col2 = ["a", "b", "c", "d", "e"],
            col3 = [10, 20, 30, 40, 50],
            col4 = ["A", "B", "C", "D", "E"],
            col5 = [100.0, 200.0, 300.0, 400.0, 500.0],
            split = ["train", "train", "train", "valid", "valid"],
        )
        td = TableDataset(testtable)
        @testset for fn in (Tables.istable,
                            Tables.rowaccess, Tables.rows,
                            Tables.columnaccess, Tables.columns,
                            Tables.schema, Tables.materializer)
            @test fn(td) == fn(testtable)
        end
    end
end
