name         := "WFMU ATH Aggregator"
version      := "0.0.1"
organization := "wfmu"

scalaVersion := "2.10.5"

libraryDependencies ++= Seq("org.apache.spark" %% "spark-core" % "1.6.1",
  "org.apache.spark" %% "spark-sql" % "1.6.1")
resolvers += Resolver.mavenLocal
