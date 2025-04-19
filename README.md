# Application Monitoring Dashboard

A real-time log analytics platform that collects, processes, and visualizes application metrics using Grafana, Kafka, and MySQL.

## 🚀 Features

- Real-time log ingestion and processing
- Request count tracking per endpoint
- Response time trend analysis
- Error rate monitoring and breakdown
- Performance metrics visualization
- Containerized deployment
- Scalable architecture

## 🏗️ Architecture

```
Application_Monitoring_Dashboards/
├── api_server/              # FastAPI REST server
│   ├── Dockerfile   
│   ├── main.py             # API endpoints
│   └── requirements.txt    # Python dependencies
├── docker/
│   └── docker-compose.yml  # Container orchestration
├── kafka/
│   ├── producer.py         # Log producer
│   └── topics.sh          # Kafka topic setup
├── Kafka_consumer/
│   └── consumer.py        # Log processor
├── workload_simulator/
│   └── simulate_requests.py # API load generator
└── grafana/               # Grafana dashboards
```

## 🛠️ Technology Stack

- **Containerization**: Docker
- **Message Broker**: Apache Kafka
- **Database**: MySQL
- **Visualization**: Grafana
- **API Framework**: FastAPI
- **Programming Language**: Python

## 📋 Prerequisites

- Docker and Docker Compose
- Python 3.8+
- MySQL Server
- Git

## 🚀 Getting Started

### 1. Database Setup

```sql
-- Create MySQL user
CREATE USER 'new_user'@'%' IDENTIFIED BY 'angel123';
GRANT ALL PRIVILEGES ON *.* TO 'new_user'@'%';
FLUSH PRIVILEGES;

-- Create database
CREATE DATABASE logs_db;
```

### 2. Environment Setup

```bash
# Clone the repository
git clone <repository-url>
cd Application_Monitoring_Dashboards

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: .\venv\Scripts\activate
```

### 3. Running the Application

1. Start the core services:
```bash
cd docker
docker-compose up --build
```

2. Start the workload simulator:
```bash
cd ../workload_simulator
python3 simulate_requests.py
```

3. Start the Kafka producer:
```bash
cd ../kafka
python3 producer.py
```

4. Start the Kafka consumer:
```bash
cd ../Kafka_consumer
python3 consumer.py
```

## 📊 Grafana Dashboards

### 1. Error Breakdown Panel
- **Type**: Table
- **Purpose**: Shows top 10 most frequent errors by endpoint
- **Query**:
```sql
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

### 2. Error Rate
- **Type**: Time Series
- **Purpose**: Displays error percentage over time
- **Query**:
```sql
SELECT
  FROM_UNIXTIME(FLOOR(timestamp/60)*60) AS time,
  100.0 * SUM(CASE WHEN status = 'error' THEN 1 ELSE 0 END) / COUNT(*) AS error_percentage
FROM logs
GROUP BY time
ORDER BY time
```

### 3. Response Time Trend
- **Type**: Time Series
- **Purpose**: Shows response time patterns with percentiles
- **Query**:
```sql
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

### 4. Request Count Per Endpoint
- **Type**: Time Series
- **Purpose**: Tracks API endpoint usage
- **Query**:
```sql
SELECT
  FROM_UNIXTIME(FLOOR(timestamp)) AS time,
  endpoint,
  COUNT(*) AS count
FROM logs
GROUP BY time, endpoint
ORDER BY time ASC
```

### 5. Top Slow Endpoints
- **Type**: Bar Graph
- **Purpose**: Identifies performance bottlenecks
- **Query**:
```sql
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

## 🔍 API Endpoints

- `GET /health` - Health check endpoint
- `GET /status` - Service status and uptime
- `GET /users` - List users
- `GET /products` - List products
- `GET /orders` - List orders
- `POST /users` - Create new user
- `POST /products` - Create new product
- `GET /simulate` - Simulate response delay
- `GET /errors` - Simulate error scenarios
- `GET /logs` - Retrieve sample logs

## 🔧 Configuration

### Environment Variables

- `KAFKA_BROKER`: Kafka broker address (default: localhost:9092)
- `KAFKA_TOPIC`: Kafka topic name (default: api-logs)
- `MYSQL_HOST`: MySQL host address
- `MYSQL_PORT`: MySQL port (default: 3306)
- `MYSQL_USER`: MySQL username
- `MYSQL_PASSWORD`: MySQL password
- `MYSQL_DATABASE`: Database name (default: logs_db)

## 📈 Monitoring Metrics

- Request count per endpoint
- Response time (avg, p95, p99)
- Error rates and types
- Endpoint performance
- System health status

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- FastAPI for the web framework
- Apache Kafka for message brokering
- Grafana for visualization
- Docker for containerization