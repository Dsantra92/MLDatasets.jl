module Titanic_Tests
using Test
using DataDeps
using MLDatasets


@testset "Titanic Dataset" begin
    X = Titanic.features()
    Y = Titanic.targets()
    names = Titanic.feature_names()
    @test X isa Matrix{}
    @test Y isa Matrix{}
    @test names == ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
    @test size(X) == (11, 891)
    @test size(Y) == (1, 891)
end

end #module