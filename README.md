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