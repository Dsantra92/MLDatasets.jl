
@testset "PTBLM" begin
    n_targets = 1
    n_features = ()
    Tx=Vector{String}
    Ty=Vector{String}

    for (n_obs, split) in [(42068, :train), (3761, :test)] 
        d = PTBLM(split)

        test_supervised_array_dataset(d;
            n_obs, n_targets, n_features,
            Tx, Ty)
    end
end


@testset "SMSSpamCollection" begin
    n_obs = 5574
    n_targets = 1
    n_features = ()
    Tx=String
    Ty=String
    
    d = SMSSpamCollection()
    
    test_supervised_array_dataset(d;
        n_obs, n_targets, n_features,
        Tx, Ty)
end

@testset "UD_English" begin
    n_features = ()
    Tx = Vector{Vector{String}}
    for (n_obs, split) in [(12543, :train), (2077, :test), (2001, :dev)] 
        d = UD_English(split)

        test_unsupervised_array_dataset(d;
            n_obs, n_features, Tx)
    end
end
