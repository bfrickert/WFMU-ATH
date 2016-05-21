import scala.util.matching.Regex
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
val log = sc.textFile([S3 INPUT LOCATION])
val pattern = "\\[(.*)\\] .* listener count on /(\\S+) now (\\d+)".r
val porkus = log filter (x => pattern.pattern.matcher(x).matches)
val wfmu = porkus map { line =>
    val pattern(dt_time, channel, cnt) = line
    (dt_time, channel, cnt)
}
val sqlContext = new org.apache.spark.sql.SQLContext(sc) 
import sqlContext.implicits._
import org.apache.spark.sql.functions._
var wfmu_dist1 = wfmu.toDF("dt_time", "channel", "cnt").distinct()
wfmu_dist1.registerTempTable("wfmu_dist")
log.toDF().registerTempTable("log")
var wfmu_dt = sqlContext.sql("Select log.* from (select min(dt_time) min_dt, substring(dt_time, 1,10) dt, substring(dt_time, 13,2) tm, channel from wfmu_dist group by substring(dt_time, 1,10), substring(dt_time, 13,2), channel) a join wfmu_dist b on b.dt_time = a.min_dt and b.channel = a.channel join log on substring(log._1, 2, 20) = b.dt_time where b.dt_time = '2015-12-28  06:09:44' order by a.min_dt").rdd.coalesce(1,true).saveAsTextFile([S3 OUTPUT LOCATION])

