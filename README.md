##WFMU ATH Aggregation and Listener Count Tool

###SPARK

####sbt

There is a single Scala script in both the `aggregation_hours/` and `listener_counts` directories, and each needs to be built into a Spark application with [sbt](http://www.Scala-sbt.org/). Ensure that the correct Spark version and Scala version are registered in each directory's `build.sbt` file. A surefire way to verify those versions is to run `scala-shell` at the command line and note the Spark and Scala versions displayed. 

So in each of the aforementioned directories, run `sbt package`. The Scala scripts will then be compiled into Java that can be submitted to Apache Spark.

####spark-submit

To run, for instance, the ATH aggregation application, enter the `aggregation_hours` directory and run

`spark-submit --master "local[*]" --class wfmu.spark.ATH target/[SCALA DIRECTORY]/[NAME OF .JAR FILE] [DIRECTORY HOLDING NOT-YET-PROCESSED ACCESS LOGS] [LOCATION FOR OUTPUT]`

NOTE: `[LOCATION FOR OUTPUT]` should be the name of a directory that does not yet exist. If it does already exist, the application will fail.

Run the following command from the `listener_counts` directory:

`spark-submit --master "local[*]" --class wfmu.spark.ListenerCounts target/[SCALA DIRECTORY]/[NAME OF .JAR FILE] [DIRECTORY HOLDING NOT-YET-PROCESSED ERROR LOGS] [LOCATION FOR OUTPUT]`

Be careful not to process the same log file twice.

####output

The output from each Spark job will be located in the respective `[LOCATION FOR OUTPUT]` and named `part-00000`. To append this to the visualization data sets, run `cat part-00000 >> shiny/[DATASET FILE NAME]`.

NOTE: It is probably a good practice to back up the current dataset files before appending the newly processed aggregations to them.

###SHINY

Once R and Shiny Server are installed, you can host the ATH/Listener Count visualization.

Within the `shiny/` directory, run `R -e "shiny::runApp(port=[PORT NUMBER])"` in the background.

See the visualization from `localhost:[PORT NUMBER]`.

