In order to set the benchmark pipeline, use: 

`fly -t quantcli set-pipeline --pipeline xbench --config benchmark_pipeline.yaml --load-vars-from-file secrets.yml`

In order to set the testing pipeline, use:

`fly -t quantcli set-pipeline --pipeline xstack --config pipeline.yaml`
