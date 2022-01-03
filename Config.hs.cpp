module Config(Config, data_prefix,theConfig)
where
data Config=Config {
   prefix,
   data_prefix:: String
  }

theConfig::Config 
theConfig=Config {
  prefix=PREFIX
 , data_prefix=DATA_PREFIX
 }
