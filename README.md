##WFMU ATH Aggregation and Listener Count Tool

###SPARK

####sbt

Each Scala script in `aggregation_hours/` and `listener_counts` needs to be built with [sbt](http://www.Scala-sbt.org/). Ensure that the Spark version and Scala version in build.sbt. A surefire way to verify each version is to run `scala-shell` at the command line and note the Spark and Scala versions displayed. 

In each directory, run `sbt package`. The Scala will then be compiled into Java that can be submitted to Apache Spark.

####Spark-submit

To run an application, enter its directory and run 

`spark-submit --master "local[*]" --class wfmu.spark.ATH target/[SCALA DIRECTORY]/[NAME OF .JAR FILE] [DIRECTOY OF NEW ACCESS LOGS] [LOCATION FOR OUTPUT]`

NOTE: `[LOCATION FOR OUTPUT]` should be the name of a directory that does not yet exist. If it does already exist, the application will fail.

####output

The output from each Spark job will be located in the respective `[LOCATION FOR OUTPUT]` and named `part-000000`. To append this to the visualization data sets, run `cat part-000000 >> shiny/[DATASET FILE NAME]`.

###SHINY

Once R and Shiny Server are installed.

Within the `shiny` directory, run `R -e "shiny::runApp(port=[PORT NUMBER])"` in the background.

See the visualization from `localhost:[PORT NUMBER]`.

