
Same for all tests: 
- Number of train users : 5000, Number of test users: 1000
- Test user rating bounds: 5-10 
- 100 models tested with the same input. The accuracy scores are an average for each test to reduce random error.



Features: feature 1 and feature 3

    Train user rating bounds: 50-70 
        n = 20, 10 for svd train and full
        Model type: linear regression
        Average r2_score without rounding: 0.25497742034431536
        Average r2_score with rounded prediction to nearest .5: 0.22800211045289098

        n = 20, 10 for svd train and full
        Model type: mlp, layers = (10,10,10)
        Average r2_score without rounding: 0.25719055444369615
        Average r2_score with rounded prediction to nearest .5: 0.23893305402169931

        n = 20, 10 for svd train and full
        Model type: mlp, layers = (10,10,5)
        Average r2_score without rounding: 0.25769840583281306
        Average r2_score with rounded prediction to nearest .5: 0.2338579730790375

        n = 20, 10 for svd train and full
        Model type: mlp, layers = (10,5,5)
        Average r2_score without rounding: 0.2566793068613578
        Average r2_score with rounded prediction to nearest .5: 0.23053965092422135


    Train user rating bounds: 30-50
        n = 10, 15 for svd train and full
        Model type: linear regression
        Average r2_score without rounding: 0.27338731662383964
        Average r2_score with rounded prediction to nearest .5: 0.25213661807645976

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,10,10)
        Average r2_score without rounding: 0.2753146424711614
        Average r2_score with rounded prediction to nearest .5: 0.2546462267406327

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,10,5)
        Average r2_score without rounding: 0.27639324087457673 
        Average r2_score with rounded prediction to nearest .5: 0.25894841302207205

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,5,5)
        Average r2_score without rounding: 0.272801130005713
        Average r2_score with rounded prediction to nearest .5: 0.2546462267406327


    Train user rating bounds: 11-31
        n = 10, 15 for svd train and full
        Model type: linear regression
        Average r2_score without rounding: 0.2689016213463154
        Average r2_score with rounded prediction to nearest .5: 0.26520328312495806

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,10,10)
        Average r2_score without rounding: 0.26307245414211416
        Average r2_score with rounded prediction to nearest .5: 0.2604638351867914

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,10,5)
        Average r2_score without rounding: 0.2661636459946842
        Average r2_score with rounded prediction to nearest .5: 0.2595524028909901

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,5,5)
        Average r2_score without rounding: 0.26070299990120643
        Average r2_score with rounded prediction to nearest .5: 0.24496948615816902




Features: feature 2 and feature 3

    Train user rating bounds: 30-50
        n = 10, 15 for svd train and full
        Model type: linear regression
        corpus: genres
        Average r2_score without rounding: 0.22779569071224418
        Average r2_score with rounded prediction to nearest .5: 0.2177191278249457

        n = 10, 15 for svd train and full
        Model type: linear regression
        corpus: "title", "genres","production_companies","keywords", "cast", "tagline", "overview"
        Average r2_score without rounding: 0.24918752474093955
        Average r2_score with rounded prediction to nearest .5: 0.2152095191607727

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,10,5)
        corpus: "title", "genres","production_companies","keywords", "cast", "tagline", "overview"
        Average r2_score without rounding: 0.24976592718907065
        Average r2_score with rounded prediction to nearest .5: 0.22112502529775188

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (10,5,5)
        corpus: "title", "genres","production_companies","keywords", "cast", "tagline", "overview"
        Average r2_score without rounding: 0.2525056422155743
        Average r2_score with rounded prediction to nearest .5: 0.22793682024336415

        n = 10, 15 for svd train and full
        Model type: mlp, layers = (5,5,5)
        corpus: "title", "genres","production_companies","keywords", "cast", "tagline", "overview"
        Average r2_score without rounding: 0.2482534294087106
        Average r2_score with rounded prediction to nearest .5: 0.23385232638034348

        Note: Corpus is only a valid parameter when using feature 2.




