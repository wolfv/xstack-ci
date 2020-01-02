In order to set the benchmark pipeline, use: 

`fly -t quantcli set-pipeline --pipeline xbench --config benchmark_pipeline.yml --load-vars-from=secrets.yml`

In order to set the testing pipeline, use:

`fly -t quantcli set-pipeline --pipeline xstack --config pipeline.yml`
