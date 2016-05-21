package wfmu.spark

import org.apache.spark.{SparkContext, SparkConf}
import scala.util.matching.Regex
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._

object ErrorCounts {
  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("WFMU ATH Aggregation Application")
    val sc = new SparkContext(conf)
    val log = sc.textFile(args(0))
    
    val pattern = "\\[(.*)\\] .* listener count on /(\\S+) now (\\d+)".r
    val porkus = log filter (x => pattern.pattern.matcher(x).matches)
    val wfmu = porkus map { line =>
        val pattern(dt_time, channel, cnt) = line
        (dt_time, channel, cnt)
    }
    val sqlContext = new org.apache.spark.sql.SQLContext(sc) 
    import sqlContext.implicits._
    import org.apache.spark.sql.functions._
    val wfmu_dist = wfmu.toDF("dt_time", "channel", "cnt").distinct()
    wfmu_dist.registerTempTable("wfmu_dist")
    val wfmu_dt = sqlContext.sql("select a.dt, a.tm, a.channel, max(b.cnt) cnt from (select min(dt_time) min_dt, substring(dt_time, 1,10) dt, substring(dt_time, 13,2) tm, channel from wfmu_dist group by substring(dt_time, 1,10), substring(dt_time, 13,2), channel) a join wfmu_dist b on b.dt_time = a.min_dt and b.channel = a.channel group by a.dt, a.tm, a.channel order by a.dt, a.tm")
    wfmu_dt.rdd.coalesce(1,true).map(x=>x.mkString(",")).saveAsTextFile(args(1))
  }
}
