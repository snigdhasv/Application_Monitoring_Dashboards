# Application_Monitoring_Dashboards

## Project Directory
```
Application_Monitoring_Dashboards/
├── api_server/
├    ├── Dockerfile   
├    ├── main.py
├    ├── requirements.txt           
├── docker/
├    ├── docker-compose.yml
├── kafka/
├    ├── nano.6069.save
├    ├── producer.py
├    ├── topics.sh
├── Kafka_consumer/
├    ├── consumer.py
├── workload_simulator
├    ├── simulate_requests.py
└── README.md                           
```

## Creating Database
In MySQL
```mysql
CREATE USER 'wsluser'@'%' IDENTIFIED BY 'wslpass';
GRANT ALL PRIVILEGES ON *.* TO 'wsluser'@'%';
FLUSH PRIVILEGES;
```
```mysql
CREATE DATABASE logs_db;
```

## To Run:

- inside /docker 
```bash
docker-compose up --build
```

- in another terminal - /workload_simulator 
```bash 
python3 simulate_requests.py
```
- in another terminal - /kafka
```bash 
python3 producer.py
```

- in another terminal - /KafkaConsumer 
```bash 
python3 consumer.py
```

cd ../../..
source venv/bin/activate
cd CC/AP_monitor/Application_Monitoring_Dashboards

## Grafana Dashboard
1. Error Breakdown Panel
Type: Table
Query:
```
SELECT
  endpoint,
  error,
  COUNT(*) AS error_count
FROM logs
WHERE status = 'error' AND $__timeFilter(FROM_UNIXTIME(timestamp))
GROUP BY endpoint, error
ORDER BY error_count DESC
LIMIT 10
```

2. Error Rate
Type: Time Series
Query:
```
SELECT
  FROM_UNIXTIME(FLOOR(timestamp/60)*60) AS time,
  100.0 * SUM(CASE WHEN status = 'error' THEN 1 ELSE 0 END) / COUNT(*) AS error_percentage
FROM logs
GROUP BY time
ORDER BY time
```
3. Response Time Trend
Type: Time Series
Query:
```
SELECT
  FROM_UNIXTIME(FLOOR(timestamp/60)*60) AS time,
  AVG(response_time) AS avg_time,
  MAX(CASE WHEN percentile = 95 THEN response_time END) AS p95_time,
  MAX(CASE WHEN percentile = 99 THEN response_time END) AS p99_time
FROM (
  SELECT
    timestamp,
    response_time,
    PERCENT_RANK() OVER (PARTITION BY FLOOR(timestamp/60)*60 ORDER BY response_time) * 100 AS percentile
  FROM logs
  WHERE $__timeFilter(FROM_UNIXTIME(timestamp))
) ranked
WHERE percentile BETWEEN 95 AND 100
GROUP BY time
ORDER BY time
```

4. Request Count Per endpoint
Type: Time Series
Query
```
SELECT
  FROM_UNIXTIME(FLOOR(timestamp)) AS time,
  endpoint,
  COUNT(*) AS count
FROM logs
GROUP BY time, endpoint
ORDER BY time ASC

```

5. Top Slow endpoint
Type: Bar Graph
Query:
```
SELECT
  endpoint,
  AVG(response_time) AS avg_time,
  COUNT(*) AS request_count
FROM logs
WHERE $__timeFilter(FROM_UNIXTIME(timestamp))
GROUP BY endpoint
ORDER BY avg_time DESC
LIMIT 5
```