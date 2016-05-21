import scala.util.matching.Regex
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
val log = sc.textFile("[S3 INPUT PREFIX]")
val pattern = "(\\S+) (\\S+) (\\S+) \\[(.*) \\+\\d{4}\\] \"\\S+ /(.*?) \\S+\" (\\d{3}) (\\d+) \"(.*?)\" \"(.*?)\" (\\d+)".r
val porkus = log filter (x => pattern.pattern.matcher(x).matches)
val wfmu = porkus map { line =>
    val pattern(ip_address, client_, user_, dt, channel, stat, byt, ref, agnt, secnd) = line
    (ip_address, client_, user_, dt, channel, stat, byt, ref, agnt, secnd)
}
val sqlContext = new org.apache.spark.sql.SQLContext(sc) 
import sqlContext.implicits._
import org.apache.spark.sql.functions._
val wfmu_dist = wfmu.toDF("ip_address", "client_", "user_", "dt", "channel", "stat", "byt", "ref", "agnt", "secnd").distinct()
val wfmudf = wfmu_dist.withColumn("mnth", month(from_unixtime(unix_timestamp($"dt", "dd/MMM/yyyy:HH:mm:ss") - $"secnd"))).withColumn("yr", year(from_unixtime(unix_timestamp($"dt", "dd/MMM/yyyy:HH:mm:ss") - $"secnd"))).select("ip_address", "yr", "mnth", "channel", "secnd")
wfmudf.registerTempTable("wfmudf")
val wfmu_rdd= sqlContext.sql("SELECT yr, mnth, channel, sum(cast(secnd as bigint)), count(8) cnt from wfmudf where channel not in ('admin/stats', 'admin/listmounts') and ip_address not in ('107.182.230.237', '23.23.87.53', '38.101.169.96', '173.12.15.5') group by yr, mnth, channel").rdd
wfmu_rdd.coalesce(1,true).map(x=>x.mkString(",")).saveAsTextFile("[S3 OUTPUT LOCATION]")

